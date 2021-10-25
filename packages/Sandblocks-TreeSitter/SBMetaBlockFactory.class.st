Class {
	#name : #SBMetaBlockFactory,
	#superclass : #Object,
	#instVars : [
		'grammar',
		'templateCache',
		'statementContainerTypes',
		'blockInline',
		'hardLineBreakMatcher',
		'supertypes',
		'name',
		'highlightQuery',
		'rootRuleName',
		'delimitedRules',
		'fullTokens',
		'wordRule',
		'extras',
		'noteUncapturedText',
		'aliases'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #helper }
SBMetaBlockFactory class >> compileParserIn: path name: aString [

	| filename |
	filename := 'tree-sitter-', aString, '.so'.
	self assert: (OSProcess waitForCommand: ('cd {1}; npx -p tree-sitter-cli tree-sitter generate' format: {path fullName})) exitStatus = 0.
	
	self assert: (OSProcess waitForCommand: ('cd {1}; CXXFLAGS="-I./src" CFLAGS="-I./src" make src/scanner.o' format: {path fullName})) exitStatus = 0.
	self assert: (OSProcess waitForCommand: ('cd {1}; CXXFLAGS="-I./src" CFLAGS="-I./src" make src/parser.o' format: {path fullName})) exitStatus = 0.
	self assert: (OSProcess waitForCommand: ('cd {1}; g++ -shared -fPIC -o tree-sitter-{2}.so src/parser.o src/scanner.o' format: {path fullName. aString})) exitStatus = 0.
	
	path / filename copyTo: FileDirectory default
]

{ #category : #helper }
SBMetaBlockFactory class >> fetchLibrary: aGithubString language: language [

	SBToggledCode comment: '' active: 1 do: {
		[ | path filename |
			filename := 'tree-sitter-{1}.so' format: {language}.
			path := (MCFetchGithubRepository new
				projectPath: aGithubString
				projectVersion: 'master'
				repoPath: nil) directory.
			^ path].
		[ | zip |
			zip := WebClient httpGet: 'https://api.github.com/repos/', aGithubString, '/zipball/master'.
			ZipArchive new
				readFrom: zip getContent readStream binary;
				extractAllTo: (FileDirectory default / 'tree-sitter-languages') assureExistence
					informing: nil
					overwrite: false]}
]

{ #category : #languages }
SBMetaBlockFactory class >> gdscript [

	^ SBMetaBlockFactory new
		name: 'gdscript'
		preprocess: [:f |
			f ignoreExternals: #('_newline' '_indent' '_dedent').
			f grammar rules
				at: '_string_content'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '.*'}).
			f grammar at: 'inline' put: (f grammar at: 'inline'), {'_identifier'}.
			f statementContainerTypes: {'source'. 'body'}.
			f blockInline: {'parameters'. 'expression_statement'}.
			f hardLineBreakMatcher: [:b | ((b isKindOf: SBInlineBlockLabel) and: [b label = ':']) and: [(b submorphAfter ifNotNil: #type) ~= 'type']]]
		postprocess: [:f | ]
		grammar: '{
  "name": "gdscript",
  "word": "_identifier",
  "rules": {
    "source": {
      "type": "REPEAT",
      "content": {
        "type": "SYMBOL",
        "name": "_statement"
      }
    },
    "_identifier": {
      "type": "PATTERN",
      "value": "[a-zA-Z_][a-zA-Z_0-9]*"
    },
    "identifier": {
      "type": "SYMBOL",
      "name": "_identifier"
    },
    "name": {
      "type": "SYMBOL",
      "name": "_identifier"
    },
    "type": {
      "type": "SYMBOL",
      "name": "_identifier"
    },
    "comment": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "#"
          },
          {
            "type": "PATTERN",
            "value": ".*"
          }
        ]
      }
    },
    "_semicolon": {
      "type": "STRING",
      "value": ";"
    },
    "true": {
      "type": "STRING",
      "value": "true"
    },
    "false": {
      "type": "STRING",
      "value": "false"
    },
    "null": {
      "type": "STRING",
      "value": "null"
    },
    "underscore": {
      "type": "STRING",
      "value": "_"
    },
    "static_keyword": {
      "type": "STRING",
      "value": "static"
    },
    "remote_keyword": {
      "type": "CHOICE",
      "members": [
        {
          "type": "STRING",
          "value": "remote"
        },
        {
          "type": "STRING",
          "value": "master"
        },
        {
          "type": "STRING",
          "value": "puppet"
        },
        {
          "type": "STRING",
          "value": "remotesync"
        },
        {
          "type": "STRING",
          "value": "mastersync"
        },
        {
          "type": "STRING",
          "value": "puppetsync"
        }
      ]
    },
    "escape_sequence": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "\\"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "PATTERN",
                "value": "u[a-fA-F\\d]{4}"
              },
              {
                "type": "PATTERN",
                "value": "U[a-fA-F\\d]{8}"
              },
              {
                "type": "PATTERN",
                "value": "x[a-fA-F\\d]{2}"
              },
              {
                "type": "PATTERN",
                "value": "o\\d{3}"
              },
              {
                "type": "PATTERN",
                "value": "\\r\\n"
              },
              {
                "type": "PATTERN",
                "value": "[^uxo]"
              }
            ]
          }
        ]
      }
    },
    "string": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_start"
          },
          "named": false,
          "value": "\""
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "escape_sequence"
              },
              {
                "type": "SYMBOL",
                "name": "_string_content"
              }
            ]
          }
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "\""
        }
      ]
    },
    "float": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "[0-9]+_?"
                }
              },
              {
                "type": "STRING",
                "value": "."
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[eE][\\+-]?"
                      },
                      {
                        "type": "REPEAT1",
                        "content": {
                          "type": "PATTERN",
                          "value": "[0-9]+_?"
                        }
                      }
                    ]
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              },
              {
                "type": "STRING",
                "value": "."
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "[0-9]+_?"
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[eE][\\+-]?"
                      },
                      {
                        "type": "REPEAT1",
                        "content": {
                          "type": "PATTERN",
                          "value": "[0-9]+_?"
                        }
                      }
                    ]
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "[0-9]+_?"
                }
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "PATTERN",
                    "value": "[eE][\\+-]?"
                  },
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  }
                ]
              }
            ]
          }
        ]
      }
    },
    "integer": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0x"
                  },
                  {
                    "type": "STRING",
                    "value": "0X"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[A-Fa-f0-9]+"
                }
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0o"
                  },
                  {
                    "type": "STRING",
                    "value": "0O"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[0-7]+"
                }
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0b"
                  },
                  {
                    "type": "STRING",
                    "value": "0B"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[0-1]+"
                }
              }
            ]
          },
          {
            "type": "REPEAT1",
            "content": {
              "type": "PATTERN",
              "value": "[0-9]+_?"
            }
          }
        ]
      }
    },
    "node_path": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "@"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "''"
              },
              {
                "type": "STRING",
                "value": "\""
              }
            ]
          },
          {
            "type": "PATTERN",
            "value": "[0-9a-zA-Z_/\\- ]*"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "''"
              },
              {
                "type": "STRING",
                "value": "\""
              }
            ]
          }
        ]
      }
    },
    "get_node": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "$"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "STRING",
                        "value": "''"
                      },
                      {
                        "type": "STRING",
                        "value": "\""
                      }
                    ]
                  },
                  {
                    "type": "PATTERN",
                    "value": "[0-9a-zA-Z_/\\- ]*"
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "STRING",
                        "value": "''"
                      },
                      {
                        "type": "STRING",
                        "value": "\""
                      }
                    ]
                  }
                ]
              },
              {
                "type": "PATTERN",
                "value": "[a-zA-Z_][a-zA-Z_/0-9]*"
              }
            ]
          }
        ]
      }
    },
    "_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_statements"
        },
        {
          "type": "SYMBOL",
          "name": "_compound_statement"
        }
      ]
    },
    "body": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_statements"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_indent"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SYMBOL",
                "name": "_statement"
              }
            },
            {
              "type": "SYMBOL",
              "name": "_dedent"
            }
          ]
        }
      ]
    },
    "_simple_statements": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_statement"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_semicolon"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "_simple_statement"
                  }
                ]
              }
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_semicolon"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_newline"
        }
      ]
    },
    "_simple_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "tool_statement"
        },
        {
          "type": "SYMBOL",
          "name": "signal_statement"
        },
        {
          "type": "SYMBOL",
          "name": "class_name_statement"
        },
        {
          "type": "SYMBOL",
          "name": "extends_statement"
        },
        {
          "type": "SYMBOL",
          "name": "expression_statement"
        },
        {
          "type": "SYMBOL",
          "name": "match_statement"
        },
        {
          "type": "SYMBOL",
          "name": "export_variable_statement"
        },
        {
          "type": "SYMBOL",
          "name": "onready_variable_statement"
        },
        {
          "type": "SYMBOL",
          "name": "variable_statement"
        },
        {
          "type": "SYMBOL",
          "name": "const_statement"
        },
        {
          "type": "SYMBOL",
          "name": "return_statement"
        },
        {
          "type": "SYMBOL",
          "name": "pass_statement"
        },
        {
          "type": "SYMBOL",
          "name": "break_statement"
        },
        {
          "type": "SYMBOL",
          "name": "breakpoint_statement"
        },
        {
          "type": "SYMBOL",
          "name": "continue_statement"
        }
      ]
    },
    "expression_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "SYMBOL",
          "name": "assignment"
        },
        {
          "type": "SYMBOL",
          "name": "augmented_assignment"
        }
      ]
    },
    "inferred_type": {
      "type": "CHOICE",
      "members": [
        {
          "type": "STRING",
          "value": ":="
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": ":"
            },
            {
              "type": "STRING",
              "value": "="
            }
          ]
        }
      ]
    },
    "_variable_assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "_variable_inferred_type_assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "inferred_type"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "_variable_typed_assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "type"
        },
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "_variable_typed_definition": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": ":"
            },
            {
              "type": "SYMBOL",
              "name": "type"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_variable_typed_assignment"
        }
      ]
    },
    "setter": {
      "type": "SYMBOL",
      "name": "_identifier"
    },
    "getter": {
      "type": "SYMBOL",
      "name": "_identifier"
    },
    "setget": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "setget"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "setter"
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "setter"
                },
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "SYMBOL",
                  "name": "getter"
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "SYMBOL",
                  "name": "getter"
                }
              ]
            }
          ]
        }
      ]
    },
    "_variable_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "var"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_variable_typed_definition"
                },
                {
                  "type": "SYMBOL",
                  "name": "_variable_inferred_type_assignment"
                },
                {
                  "type": "SYMBOL",
                  "name": "_variable_assignment"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "setget"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "variable_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "remote_keyword"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_variable_statement"
        }
      ]
    },
    "export_argument_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_expression"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "_expression"
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "export_variable_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "export"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "export_argument_list"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "remote_keyword"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_variable_statement"
        }
      ]
    },
    "onready_variable_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "onready"
        },
        {
          "type": "SYMBOL",
          "name": "_variable_statement"
        }
      ]
    },
    "const_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "const"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_variable_inferred_type_assignment"
            },
            {
              "type": "SYMBOL",
              "name": "_variable_typed_assignment"
            },
            {
              "type": "SYMBOL",
              "name": "_variable_assignment"
            }
          ]
        }
      ]
    },
    "return_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "return"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_expression"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "pass_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "pass"
      }
    },
    "break_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "break"
      }
    },
    "breakpoint_statement": {
      "type": "STRING",
      "value": "breakpoint"
    },
    "continue_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "continue"
      }
    },
    "tool_statement": {
      "type": "STRING",
      "value": "tool"
    },
    "signal_argument_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "identifier"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "identifier"
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "signal_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "signal"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "signal_argument_list"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "class_name_icon_path": {
      "type": "SYMBOL",
      "name": "string"
    },
    "class_name_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "class_name"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "SYMBOL",
                  "name": "class_name_icon_path"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "dotted_type": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "type"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "."
              },
              {
                "type": "SYMBOL",
                "name": "type"
              }
            ]
          }
        }
      ]
    },
    "extends_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "extends"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "dotted_type"
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "string"
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SEQ",
                      "members": [
                        {
                          "type": "STRING",
                          "value": "."
                        },
                        {
                          "type": "SYMBOL",
                          "name": "dotted_type"
                        }
                      ]
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "_compound_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "if_statement"
        },
        {
          "type": "SYMBOL",
          "name": "for_statement"
        },
        {
          "type": "SYMBOL",
          "name": "while_statement"
        },
        {
          "type": "SYMBOL",
          "name": "function_definition"
        },
        {
          "type": "SYMBOL",
          "name": "constructor_definition"
        },
        {
          "type": "SYMBOL",
          "name": "class_definition"
        },
        {
          "type": "SYMBOL",
          "name": "enum_definition"
        }
      ]
    },
    "if_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "if"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SYMBOL",
            "name": "elif_clause"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "else_clause"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "elif_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "elif"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "else_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "else"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "for_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "for"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "STRING",
          "value": "in"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "while_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "while"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "class_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "class"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "extends_statement"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "enum_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "enum"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "name"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "enumerator_list"
        }
      ]
    },
    "enumerator_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "enumerator"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "enumerator"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "_enumerator_expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "integer"
        },
        {
          "type": "SYMBOL",
          "name": "binary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "unary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "attribute"
        },
        {
          "type": "SYMBOL",
          "name": "subscript"
        },
        {
          "type": "SYMBOL",
          "name": "call"
        },
        {
          "type": "SYMBOL",
          "name": "parenthesized_expression"
        }
      ]
    },
    "enumerator": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "="
                },
                {
                  "type": "SYMBOL",
                  "name": "_enumerator_expression"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "match_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "match"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "match_body"
        }
      ]
    },
    "match_body": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_indent"
        },
        {
          "type": "REPEAT1",
          "content": {
            "type": "SYMBOL",
            "name": "pattern_section"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_dedent"
        }
      ]
    },
    "pattern_section": {
      "type": "SEQ",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_pattern"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "_pattern"
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "_pattern": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "pattern_array"
        },
        {
          "type": "SYMBOL",
          "name": "pattern_dictionary"
        },
        {
          "type": "SYMBOL",
          "name": "pattern_binding"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "underscore"
        },
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "SYMBOL",
          "name": "integer"
        },
        {
          "type": "SYMBOL",
          "name": "float"
        },
        {
          "type": "SYMBOL",
          "name": "true"
        },
        {
          "type": "SYMBOL",
          "name": "false"
        },
        {
          "type": "SYMBOL",
          "name": "null"
        }
      ]
    },
    "pattern_binding": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "var"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        }
      ]
    },
    "pattern_open_ending": {
      "type": "STRING",
      "value": ".."
    },
    "pattern_array": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_pattern"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "pattern_open_ending"
                    }
                  ]
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "SYMBOL",
                            "name": "_pattern"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "pattern_open_ending"
                          }
                        ]
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "pattern_dictionary": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "pattern_pair"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "pattern_open_ending"
                    }
                  ]
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "SYMBOL",
                            "name": "pattern_pair"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "pattern_open_ending"
                          }
                        ]
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "pattern_pair": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "_pattern"
        }
      ]
    },
    "_expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "comparison_operator"
        },
        {
          "type": "SYMBOL",
          "name": "_primary_expression"
        },
        {
          "type": "SYMBOL",
          "name": "conditional_expression"
        }
      ]
    },
    "_primary_expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "binary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "SYMBOL",
          "name": "integer"
        },
        {
          "type": "SYMBOL",
          "name": "float"
        },
        {
          "type": "SYMBOL",
          "name": "true"
        },
        {
          "type": "SYMBOL",
          "name": "false"
        },
        {
          "type": "SYMBOL",
          "name": "null"
        },
        {
          "type": "SYMBOL",
          "name": "unary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "node_path"
        },
        {
          "type": "SYMBOL",
          "name": "get_node"
        },
        {
          "type": "SYMBOL",
          "name": "attribute"
        },
        {
          "type": "SYMBOL",
          "name": "subscript"
        },
        {
          "type": "SYMBOL",
          "name": "base_call"
        },
        {
          "type": "SYMBOL",
          "name": "call"
        },
        {
          "type": "SYMBOL",
          "name": "array"
        },
        {
          "type": "SYMBOL",
          "name": "dictionary"
        },
        {
          "type": "SYMBOL",
          "name": "parenthesized_expression"
        }
      ]
    },
    "_attribute_expression": {
      "type": "PREC",
      "value": 17,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SYMBOL",
            "name": "binary_operator"
          },
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "SYMBOL",
            "name": "string"
          },
          {
            "type": "SYMBOL",
            "name": "integer"
          },
          {
            "type": "SYMBOL",
            "name": "float"
          },
          {
            "type": "SYMBOL",
            "name": "true"
          },
          {
            "type": "SYMBOL",
            "name": "false"
          },
          {
            "type": "SYMBOL",
            "name": "null"
          },
          {
            "type": "SYMBOL",
            "name": "unary_operator"
          },
          {
            "type": "SYMBOL",
            "name": "node_path"
          },
          {
            "type": "SYMBOL",
            "name": "get_node"
          },
          {
            "type": "SYMBOL",
            "name": "subscript"
          },
          {
            "type": "SYMBOL",
            "name": "base_call"
          },
          {
            "type": "SYMBOL",
            "name": "call"
          },
          {
            "type": "SYMBOL",
            "name": "array"
          },
          {
            "type": "SYMBOL",
            "name": "dictionary"
          },
          {
            "type": "SYMBOL",
            "name": "parenthesized_expression"
          }
        ]
      }
    },
    "binary_operator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC_LEFT",
          "value": 4,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "and"
                  },
                  {
                    "type": "STRING",
                    "value": "&&"
                  }
                ]
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 3,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "or"
                  },
                  {
                    "type": "STRING",
                    "value": "||"
                  }
                ]
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 9,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "+"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 9,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "-"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "*"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "/"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "%"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 5,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "|"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 6,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "&"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 7,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "^"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 8,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "<<"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 8,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": ">>"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 13,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "is"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 14,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              },
              {
                "type": "STRING",
                "value": "as"
              },
              {
                "type": "SYMBOL",
                "name": "identifier"
              }
            ]
          }
        }
      ]
    },
    "unary_operator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC",
          "value": 12,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "not"
                  },
                  {
                    "type": "STRING",
                    "value": "!"
                  }
                ]
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC",
          "value": 12,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "-"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC",
          "value": 12,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "+"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        },
        {
          "type": "PREC",
          "value": 12,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "~"
              },
              {
                "type": "SYMBOL",
                "name": "_primary_expression"
              }
            ]
          }
        }
      ]
    },
    "comparison_operator": {
      "type": "PREC_LEFT",
      "value": 2,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_primary_expression"
          },
          {
            "type": "REPEAT1",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "<"
                    },
                    {
                      "type": "STRING",
                      "value": "<="
                    },
                    {
                      "type": "STRING",
                      "value": "=="
                    },
                    {
                      "type": "STRING",
                      "value": "!="
                    },
                    {
                      "type": "STRING",
                      "value": ">="
                    },
                    {
                      "type": "STRING",
                      "value": ">"
                    },
                    {
                      "type": "STRING",
                      "value": "in"
                    },
                    {
                      "type": "STRING",
                      "value": "is"
                    }
                  ]
                },
                {
                  "type": "SYMBOL",
                  "name": "_primary_expression"
                }
              ]
            }
          }
        ]
      }
    },
    "subscript": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_primary_expression"
        },
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "attribute_call": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "SYMBOL",
            "name": "argument_list"
          }
        ]
      }
    },
    "attribute_subscript": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "STRING",
            "value": "["
          },
          {
            "type": "SYMBOL",
            "name": "_primary_expression"
          },
          {
            "type": "STRING",
            "value": "]"
          }
        ]
      }
    },
    "attribute": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_attribute_expression"
          },
          {
            "type": "REPEAT1",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "."
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "attribute_subscript"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "attribute_call"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "identifier"
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    },
    "conditional_expression": {
      "type": "PREC_RIGHT",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_expression"
          },
          {
            "type": "STRING",
            "value": "if"
          },
          {
            "type": "SYMBOL",
            "name": "_expression"
          },
          {
            "type": "STRING",
            "value": "else"
          },
          {
            "type": "SYMBOL",
            "name": "_expression"
          }
        ]
      }
    },
    "parenthesized_expression": {
      "type": "PREC",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "("
          },
          {
            "type": "SYMBOL",
            "name": "_expression"
          },
          {
            "type": "STRING",
            "value": ")"
          }
        ]
      }
    },
    "assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "augmented_assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_expression"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "+="
            },
            {
              "type": "STRING",
              "value": "-="
            },
            {
              "type": "STRING",
              "value": "*="
            },
            {
              "type": "STRING",
              "value": "/="
            },
            {
              "type": "STRING",
              "value": "%="
            },
            {
              "type": "STRING",
              "value": ">>="
            },
            {
              "type": "STRING",
              "value": "<<="
            },
            {
              "type": "STRING",
              "value": "&="
            },
            {
              "type": "STRING",
              "value": "^="
            },
            {
              "type": "STRING",
              "value": "|="
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "pair": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_expression"
                },
                {
                  "type": "STRING",
                  "value": ":"
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "identifier"
                },
                {
                  "type": "STRING",
                  "value": "="
                }
              ]
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "dictionary": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "pair"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "pair"
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "array": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_expression"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "_expression"
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "typed_parameter": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "SYMBOL",
            "name": "type"
          }
        ]
      }
    },
    "default_parameter": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "typed_default_parameter": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "SYMBOL",
            "name": "type"
          },
          {
            "type": "STRING",
            "value": "="
          },
          {
            "type": "SYMBOL",
            "name": "_expression"
          }
        ]
      }
    },
    "_parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "identifier"
            },
            {
              "type": "SYMBOL",
              "name": "typed_parameter"
            },
            {
              "type": "SYMBOL",
              "name": "default_parameter"
            },
            {
              "type": "SYMBOL",
              "name": "typed_default_parameter"
            }
          ]
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "identifier"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "typed_parameter"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "default_parameter"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "typed_default_parameter"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_parameters"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "return_type": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "->"
        },
        {
          "type": "SYMBOL",
          "name": "type"
        }
      ]
    },
    "function_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "static_keyword"
                },
                {
                  "type": "SYMBOL",
                  "name": "remote_keyword"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "func"
        },
        {
          "type": "SYMBOL",
          "name": "name"
        },
        {
          "type": "SYMBOL",
          "name": "parameters"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "return_type"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "constructor_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "func"
        },
        {
          "type": "STRING",
          "value": "_init"
        },
        {
          "type": "SYMBOL",
          "name": "parameters"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "."
                },
                {
                  "type": "SYMBOL",
                  "name": "argument_list"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "return_type"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "body"
        }
      ]
    },
    "argument_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_expression"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "_expression"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "base_call": {
      "type": "PREC",
      "value": 15,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "."
          },
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "SYMBOL",
            "name": "argument_list"
          }
        ]
      }
    },
    "call": {
      "type": "PREC",
      "value": 15,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_primary_expression"
          },
          {
            "type": "SYMBOL",
            "name": "argument_list"
          }
        ]
      }
    }
  },
  "extras": [
    {
      "type": "SYMBOL",
      "name": "comment"
    },
    {
      "type": "PATTERN",
      "value": "[\\s\\uFEFF\\u2060\\u200B]|\\\\\\r?\\n"
    }
  ],
  "conflicts": [],
  "precedences": [],
  "externals": [
    {
      "type": "SYMBOL",
      "name": "_newline"
    },
    {
      "type": "SYMBOL",
      "name": "_indent"
    },
    {
      "type": "SYMBOL",
      "name": "_dedent"
    },
    {
      "type": "SYMBOL",
      "name": "_string_start"
    },
    {
      "type": "SYMBOL",
      "name": "_string_content"
    },
    {
      "type": "SYMBOL",
      "name": "_string_end"
    }
  ],
  "inline": [
    "_simple_statement",
    "_compound_statement",
    "ReferenceError"
  ],
  "supertypes": []
}

'
		highlight: ''
]

{ #category : #helper }
SBMetaBlockFactory class >> generateFFIMethodFor: aName [

	SBTreeSitter
		compile: ('{1}

	<apicall: SBTSLanguage* tree_sitter_{1} () module: ''tree-sitter-{1}''>
	^ self externalCallFailed' format: {aName})
		classified: 'ffi languages'
]

{ #category : #helper }
SBMetaBlockFactory class >> generateGrammarMethodFrom: path name: aString [

	| grammarFile highlightsFile |
	[
		grammarFile := path / 'src' / 'grammar.json' in: [:file | file exists ifTrue: [FileStream readOnlyFileNamed: file fullName]  ifFalse: [nil]].
		highlightsFile := path / 'queries' / 'highlights.scm' in: [:file | file exists ifTrue: [FileStream readOnlyFileNamed: file fullName]  ifFalse: [nil]].
		
		self class
			compile: ('{4}

		^ SBMetaBlockFactory new name: {1} preprocess: [:f|] postprocess: [:f|] grammar: {2} highlight: {3}' format: {aString storeString. grammarFile contents storeString. highlightsFile ifNotNil: [:f | f contents storeString] ifNil: ['''''']. aString})
			classified: 'languages'] ensure: [
				grammarFile ifNotNil: #close.
				highlightsFile ifNotNil: #close]
]

{ #category : #languages }
SBMetaBlockFactory class >> javascript [

	^ SBMetaBlockFactory new
		name: 'javascript'
		preprocess: [:f | | rulesWithSemicolon |
			f grammar rules
				at: '_automatic_semicolon'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> ''}).
			f grammar rules
				at: '_template_chars'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '.*'}).
			rulesWithSemicolon := ((f grammar rules associations collect: [:pair |
				f
					traverse: pair value
					detect: [:obj | obj type = 'SYMBOL' and: [obj name = '_semicolon']]
					ifFound: [:obj | pair key -> ';']
					ifNone: [nil]]) select: #notNil) as: Dictionary.
			f addDelimitedRules: rulesWithSemicolon.
			f grammar at: 'inline' put: f grammar inline, {'_ternary_qmark'}.
			f grammar rules statement members: (f grammar rules statement members reject: [:m | m name = 'labeled_statement'])]
		postprocess: [:f |
			f rootRuleName: 'program'.
			f addDelimitedRules: ({'object' -> ','} as: Dictionary).
			f blockInline: {'expression_statement'. 'arguments'}.
			f statementContainerTypes: #('program' 'statement_block')]
		grammar: '{
	  "name": "javascript",
	  "word": "identifier",
	  "rules": {
	    "program": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "hash_bang_line"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        }
	      ]
	    },
	    "hash_bang_line": {
	      "type": "PATTERN",
	      "value": "#!.*"
	    },
	    "export_statement": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "export"
	            },
	            {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": "*"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_from_clause"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_semicolon"
	                    }
	                  ]
	                },
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "ALIAS",
	                      "content": {
	                        "type": "SYMBOL",
	                        "name": "namespace_import_export"
	                      },
	                      "named": true,
	                      "value": "namespace_export"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_from_clause"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_semicolon"
	                    }
	                  ]
	                },
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "export_clause"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_from_clause"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_semicolon"
	                    }
	                  ]
	                },
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "export_clause"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "_semicolon"
	                    }
	                  ]
	                }
	              ]
	            }
	          ]
	        },
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "REPEAT",
	              "content": {
	                "type": "FIELD",
	                "name": "decorator",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "decorator"
	                }
	              }
	            },
	            {
	              "type": "STRING",
	              "value": "export"
	            },
	            {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "FIELD",
	                  "name": "declaration",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "declaration"
	                  }
	                },
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": "default"
	                    },
	                    {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "FIELD",
	                          "name": "declaration",
	                          "content": {
	                            "type": "SYMBOL",
	                            "name": "declaration"
	                          }
	                        },
	                        {
	                          "type": "SEQ",
	                          "members": [
	                            {
	                              "type": "FIELD",
	                              "name": "value",
	                              "content": {
	                                "type": "SYMBOL",
	                                "name": "expression"
	                              }
	                            },
	                            {
	                              "type": "SYMBOL",
	                              "name": "_semicolon"
	                            }
	                          ]
	                        }
	                      ]
	                    }
	                  ]
	                }
	              ]
	            }
	          ]
	        }
	      ]
	    },
	    "export_clause": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "{"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "ALIAS",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "_import_export_specifier"
	                  },
	                  "named": true,
	                  "value": "export_specifier"
	                },
	                {
	                  "type": "REPEAT",
	                  "content": {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ","
	                      },
	                      {
	                        "type": "ALIAS",
	                        "content": {
	                          "type": "SYMBOL",
	                          "name": "_import_export_specifier"
	                        },
	                        "named": true,
	                        "value": "export_specifier"
	                      }
	                    ]
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": ","
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "_import_export_specifier": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "name",
	          "content": {
	            "type": "SYMBOL",
	            "name": "identifier"
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "as"
	                },
	                {
	                  "type": "FIELD",
	                  "name": "alias",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "identifier"
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "declaration": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "function_declaration"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "generator_function_declaration"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "class_declaration"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "lexical_declaration"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "variable_declaration"
	        }
	      ]
	    },
	    "import": {
	      "type": "TOKEN",
	      "content": {
	        "type": "STRING",
	        "value": "import"
	      }
	    },
	    "import_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "import"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "import_clause"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "_from_clause"
	                }
	              ]
	            },
	            {
	              "type": "FIELD",
	              "name": "source",
	              "content": {
	                "type": "SYMBOL",
	                "name": "string"
	              }
	            }
	          ]
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "import_clause": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "namespace_import_export"
	          },
	          "named": true,
	          "value": "namespace_import"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "named_imports"
	        },
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "identifier"
	            },
	            {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": ","
	                    },
	                    {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "ALIAS",
	                          "content": {
	                            "type": "SYMBOL",
	                            "name": "namespace_import_export"
	                          },
	                          "named": true,
	                          "value": "namespace_import"
	                        },
	                        {
	                          "type": "SYMBOL",
	                          "name": "named_imports"
	                        }
	                      ]
	                    }
	                  ]
	                },
	                {
	                  "type": "BLANK"
	                }
	              ]
	            }
	          ]
	        }
	      ]
	    },
	    "_from_clause": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "from"
	        },
	        {
	          "type": "FIELD",
	          "name": "source",
	          "content": {
	            "type": "SYMBOL",
	            "name": "string"
	          }
	        }
	      ]
	    },
	    "namespace_import_export": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "*"
	        },
	        {
	          "type": "STRING",
	          "value": "as"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "identifier"
	        }
	      ]
	    },
	    "named_imports": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "{"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "ALIAS",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "_import_export_specifier"
	                  },
	                  "named": true,
	                  "value": "import_specifier"
	                },
	                {
	                  "type": "REPEAT",
	                  "content": {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ","
	                      },
	                      {
	                        "type": "ALIAS",
	                        "content": {
	                          "type": "SYMBOL",
	                          "name": "_import_export_specifier"
	                        },
	                        "named": true,
	                        "value": "import_specifier"
	                      }
	                    ]
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": ","
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "statement": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "export_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "import_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "debugger_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "expression_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "declaration"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "statement_block"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "if_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "switch_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "for_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "for_in_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "while_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "do_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "try_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "with_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "break_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "continue_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "return_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "throw_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "empty_statement"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "labeled_statement"
	        }
	      ]
	    },
	    "expression_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "_expressions"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "variable_declaration": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "var"
	        },
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "variable_declarator"
	            },
	            {
	              "type": "REPEAT",
	              "content": {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": ","
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "variable_declarator"
	                  }
	                ]
	              }
	            }
	          ]
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "lexical_declaration": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "kind",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "let"
	              },
	              {
	                "type": "STRING",
	                "value": "const"
	              }
	            ]
	          }
	        },
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "variable_declarator"
	            },
	            {
	              "type": "REPEAT",
	              "content": {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": ","
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "variable_declarator"
	                  }
	                ]
	              }
	            }
	          ]
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "variable_declarator": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "name",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "identifier"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "_destructuring_pattern"
	              }
	            ]
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "_initializer"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "statement_block": {
	      "type": "PREC_RIGHT",
	      "value": 0,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "{"
	          },
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement"
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "}"
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_automatic_semicolon"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "else_clause": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "else"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "statement"
	        }
	      ]
	    },
	    "if_statement": {
	      "type": "PREC_RIGHT",
	      "value": 0,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "if"
	          },
	          {
	            "type": "FIELD",
	            "name": "condition",
	            "content": {
	              "type": "SYMBOL",
	              "name": "parenthesized_expression"
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "consequence",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement"
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "alternative",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "else_clause"
	                }
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "switch_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "switch"
	        },
	        {
	          "type": "FIELD",
	          "name": "value",
	          "content": {
	            "type": "SYMBOL",
	            "name": "parenthesized_expression"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "switch_body"
	          }
	        }
	      ]
	    },
	    "for_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "for"
	        },
	        {
	          "type": "STRING",
	          "value": "("
	        },
	        {
	          "type": "FIELD",
	          "name": "initializer",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "lexical_declaration"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "variable_declaration"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "expression_statement"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "empty_statement"
	              }
	            ]
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "condition",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "expression_statement"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "empty_statement"
	              }
	            ]
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "increment",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_expressions"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ")"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        }
	      ]
	    },
	    "for_in_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "for"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "await"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_for_header"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        }
	      ]
	    },
	    "_for_header": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "("
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "FIELD",
	              "name": "left",
	              "content": {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "SYMBOL",
	                    "name": "_lhs_expression"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "parenthesized_expression"
	                  }
	                ]
	              }
	            },
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "FIELD",
	                  "name": "kind",
	                  "content": {
	                    "type": "STRING",
	                    "value": "var"
	                  }
	                },
	                {
	                  "type": "FIELD",
	                  "name": "left",
	                  "content": {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "SYMBOL",
	                        "name": "identifier"
	                      },
	                      {
	                        "type": "SYMBOL",
	                        "name": "_destructuring_pattern"
	                      }
	                    ]
	                  }
	                },
	                {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "_initializer"
	                    },
	                    {
	                      "type": "BLANK"
	                    }
	                  ]
	                }
	              ]
	            },
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "FIELD",
	                  "name": "kind",
	                  "content": {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": "let"
	                      },
	                      {
	                        "type": "STRING",
	                        "value": "const"
	                      }
	                    ]
	                  }
	                },
	                {
	                  "type": "FIELD",
	                  "name": "left",
	                  "content": {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "SYMBOL",
	                        "name": "identifier"
	                      },
	                      {
	                        "type": "SYMBOL",
	                        "name": "_destructuring_pattern"
	                      }
	                    ]
	                  }
	                }
	              ]
	            }
	          ]
	        },
	        {
	          "type": "FIELD",
	          "name": "operator",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "in"
	              },
	              {
	                "type": "STRING",
	                "value": "of"
	              }
	            ]
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "right",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_expressions"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ")"
	        }
	      ]
	    },
	    "while_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "while"
	        },
	        {
	          "type": "FIELD",
	          "name": "condition",
	          "content": {
	            "type": "SYMBOL",
	            "name": "parenthesized_expression"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        }
	      ]
	    },
	    "do_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "do"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "while"
	        },
	        {
	          "type": "FIELD",
	          "name": "condition",
	          "content": {
	            "type": "SYMBOL",
	            "name": "parenthesized_expression"
	          }
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "try_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "try"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement_block"
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "FIELD",
	              "name": "handler",
	              "content": {
	                "type": "SYMBOL",
	                "name": "catch_clause"
	              }
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "FIELD",
	              "name": "finalizer",
	              "content": {
	                "type": "SYMBOL",
	                "name": "finally_clause"
	              }
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "with_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "with"
	        },
	        {
	          "type": "FIELD",
	          "name": "object",
	          "content": {
	            "type": "SYMBOL",
	            "name": "parenthesized_expression"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement"
	          }
	        }
	      ]
	    },
	    "break_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "break"
	        },
	        {
	          "type": "FIELD",
	          "name": "label",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "ALIAS",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                "named": true,
	                "value": "statement_identifier"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "continue_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "continue"
	        },
	        {
	          "type": "FIELD",
	          "name": "label",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "ALIAS",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                "named": true,
	                "value": "statement_identifier"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "debugger_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "debugger"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "return_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "return"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "_expressions"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "throw_statement": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "throw"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_expressions"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_semicolon"
	        }
	      ]
	    },
	    "empty_statement": {
	      "type": "STRING",
	      "value": ";"
	    },
	    "labeled_statement": {
	      "type": "PREC_DYNAMIC",
	      "value": -1,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "label",
	            "content": {
	              "type": "ALIAS",
	              "content": {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "SYMBOL",
	                    "name": "identifier"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "_reserved_identifier"
	                  }
	                ]
	              },
	              "named": true,
	              "value": "statement_identifier"
	            }
	          },
	          {
	            "type": "STRING",
	            "value": ":"
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement"
	            }
	          }
	        ]
	      }
	    },
	    "switch_body": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "{"
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "switch_case"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "switch_default"
	              }
	            ]
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "switch_case": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "case"
	        },
	        {
	          "type": "FIELD",
	          "name": "value",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_expressions"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ":"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "REPEAT",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement"
	            }
	          }
	        }
	      ]
	    },
	    "switch_default": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "default"
	        },
	        {
	          "type": "STRING",
	          "value": ":"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "REPEAT",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement"
	            }
	          }
	        }
	      ]
	    },
	    "catch_clause": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "catch"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "("
	                },
	                {
	                  "type": "FIELD",
	                  "name": "parameter",
	                  "content": {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "SYMBOL",
	                        "name": "identifier"
	                      },
	                      {
	                        "type": "SYMBOL",
	                        "name": "_destructuring_pattern"
	                      }
	                    ]
	                  }
	                },
	                {
	                  "type": "STRING",
	                  "value": ")"
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement_block"
	          }
	        }
	      ]
	    },
	    "finally_clause": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "finally"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement_block"
	          }
	        }
	      ]
	    },
	    "parenthesized_expression": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "("
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_expressions"
	        },
	        {
	          "type": "STRING",
	          "value": ")"
	        }
	      ]
	    },
	    "_expressions": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "sequence_expression"
	        }
	      ]
	    },
	    "expression": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "primary_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_element"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_fragment"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "assignment_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "augmented_assignment_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "await_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "unary_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "binary_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "ternary_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "update_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "new_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "yield_expression"
	        }
	      ]
	    },
	    "primary_expression": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "subscript_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "member_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "parenthesized_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_identifier"
	        },
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_reserved_identifier"
	          },
	          "named": true,
	          "value": "identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "this"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "super"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "number"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "string"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "template_string"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "regex"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "true"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "false"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "null"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "import"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "object"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "array"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "function"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "arrow_function"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "generator_function"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "class"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "meta_property"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "call_expression"
	        }
	      ]
	    },
	    "yield_expression": {
	      "type": "PREC_RIGHT",
	      "value": 0,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "yield"
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "*"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "expression"
	                  }
	                ]
	              },
	              {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "SYMBOL",
	                    "name": "expression"
	                  },
	                  {
	                    "type": "BLANK"
	                  }
	                ]
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "object": {
	      "type": "PREC",
	      "value": "object",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "{"
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "SYMBOL",
	                            "name": "pair"
	                          },
	                          {
	                            "type": "SYMBOL",
	                            "name": "spread_element"
	                          },
	                          {
	                            "type": "SYMBOL",
	                            "name": "method_definition"
	                          },
	                          {
	                            "type": "ALIAS",
	                            "content": {
	                              "type": "CHOICE",
	                              "members": [
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "identifier"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "_reserved_identifier"
	                                }
	                              ]
	                            },
	                            "named": true,
	                            "value": "shorthand_property_identifier"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "REPEAT",
	                    "content": {
	                      "type": "SEQ",
	                      "members": [
	                        {
	                          "type": "STRING",
	                          "value": ","
	                        },
	                        {
	                          "type": "CHOICE",
	                          "members": [
	                            {
	                              "type": "CHOICE",
	                              "members": [
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "pair"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "spread_element"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "method_definition"
	                                },
	                                {
	                                  "type": "ALIAS",
	                                  "content": {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "SYMBOL",
	                                        "name": "identifier"
	                                      },
	                                      {
	                                        "type": "SYMBOL",
	                                        "name": "_reserved_identifier"
	                                      }
	                                    ]
	                                  },
	                                  "named": true,
	                                  "value": "shorthand_property_identifier"
	                                }
	                              ]
	                            },
	                            {
	                              "type": "BLANK"
	                            }
	                          ]
	                        }
	                      ]
	                    }
	                  }
	                ]
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "}"
	          }
	        ]
	      }
	    },
	    "object_pattern": {
	      "type": "PREC",
	      "value": "object",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "{"
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "SYMBOL",
	                            "name": "pair_pattern"
	                          },
	                          {
	                            "type": "SYMBOL",
	                            "name": "rest_pattern"
	                          },
	                          {
	                            "type": "SYMBOL",
	                            "name": "object_assignment_pattern"
	                          },
	                          {
	                            "type": "ALIAS",
	                            "content": {
	                              "type": "CHOICE",
	                              "members": [
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "identifier"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "_reserved_identifier"
	                                }
	                              ]
	                            },
	                            "named": true,
	                            "value": "shorthand_property_identifier_pattern"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "REPEAT",
	                    "content": {
	                      "type": "SEQ",
	                      "members": [
	                        {
	                          "type": "STRING",
	                          "value": ","
	                        },
	                        {
	                          "type": "CHOICE",
	                          "members": [
	                            {
	                              "type": "CHOICE",
	                              "members": [
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "pair_pattern"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "rest_pattern"
	                                },
	                                {
	                                  "type": "SYMBOL",
	                                  "name": "object_assignment_pattern"
	                                },
	                                {
	                                  "type": "ALIAS",
	                                  "content": {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "SYMBOL",
	                                        "name": "identifier"
	                                      },
	                                      {
	                                        "type": "SYMBOL",
	                                        "name": "_reserved_identifier"
	                                      }
	                                    ]
	                                  },
	                                  "named": true,
	                                  "value": "shorthand_property_identifier_pattern"
	                                }
	                              ]
	                            },
	                            {
	                              "type": "BLANK"
	                            }
	                          ]
	                        }
	                      ]
	                    }
	                  }
	                ]
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "}"
	          }
	        ]
	      }
	    },
	    "assignment_pattern": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "left",
	          "content": {
	            "type": "SYMBOL",
	            "name": "pattern"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "="
	        },
	        {
	          "type": "FIELD",
	          "name": "right",
	          "content": {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        }
	      ]
	    },
	    "object_assignment_pattern": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "left",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "ALIAS",
	                "content": {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "_reserved_identifier"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "identifier"
	                    }
	                  ]
	                },
	                "named": true,
	                "value": "shorthand_property_identifier_pattern"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "_destructuring_pattern"
	              }
	            ]
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "="
	        },
	        {
	          "type": "FIELD",
	          "name": "right",
	          "content": {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        }
	      ]
	    },
	    "array": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "["
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "SYMBOL",
	                          "name": "expression"
	                        },
	                        {
	                          "type": "SYMBOL",
	                          "name": "spread_element"
	                        }
	                      ]
	                    },
	                    {
	                      "type": "BLANK"
	                    }
	                  ]
	                },
	                {
	                  "type": "REPEAT",
	                  "content": {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ","
	                      },
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "SYMBOL",
	                                "name": "expression"
	                              },
	                              {
	                                "type": "SYMBOL",
	                                "name": "spread_element"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "BLANK"
	                          }
	                        ]
	                      }
	                    ]
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "]"
	        }
	      ]
	    },
	    "array_pattern": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "["
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "SYMBOL",
	                          "name": "pattern"
	                        },
	                        {
	                          "type": "SYMBOL",
	                          "name": "assignment_pattern"
	                        }
	                      ]
	                    },
	                    {
	                      "type": "BLANK"
	                    }
	                  ]
	                },
	                {
	                  "type": "REPEAT",
	                  "content": {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ","
	                      },
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "SYMBOL",
	                                "name": "pattern"
	                              },
	                              {
	                                "type": "SYMBOL",
	                                "name": "assignment_pattern"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "BLANK"
	                          }
	                        ]
	                      }
	                    ]
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "]"
	        }
	      ]
	    },
	    "_jsx_element": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "jsx_element"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_self_closing_element"
	        }
	      ]
	    },
	    "jsx_element": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "open_tag",
	          "content": {
	            "type": "SYMBOL",
	            "name": "jsx_opening_element"
	          }
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_jsx_child"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "close_tag",
	          "content": {
	            "type": "SYMBOL",
	            "name": "jsx_closing_element"
	          }
	        }
	      ]
	    },
	    "jsx_fragment": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "<"
	        },
	        {
	          "type": "STRING",
	          "value": ">"
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_jsx_child"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "<"
	        },
	        {
	          "type": "STRING",
	          "value": "/"
	        },
	        {
	          "type": "STRING",
	          "value": ">"
	        }
	      ]
	    },
	    "jsx_text": {
	      "type": "PATTERN",
	      "value": "[^{}<>]+"
	    },
	    "jsx_expression": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "{"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "sequence_expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "spread_element"
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "_jsx_child": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "jsx_text"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_element"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_fragment"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_expression"
	        }
	      ]
	    },
	    "jsx_opening_element": {
	      "type": "PREC_DYNAMIC",
	      "value": -1,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "<"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "SYMBOL",
	              "name": "_jsx_element_name"
	            }
	          },
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "FIELD",
	              "name": "attribute",
	              "content": {
	                "type": "SYMBOL",
	                "name": "_jsx_attribute"
	              }
	            }
	          },
	          {
	            "type": "STRING",
	            "value": ">"
	          }
	        ]
	      }
	    },
	    "jsx_identifier": {
	      "type": "PATTERN",
	      "value": "[a-zA-Z_$][a-zA-Z\\d_$]*-[a-zA-Z\\d_$\\-]*"
	    },
	    "_jsx_identifier": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "jsx_identifier"
	          },
	          "named": true,
	          "value": "identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "identifier"
	        }
	      ]
	    },
	    "nested_identifier": {
	      "type": "PREC",
	      "value": "member",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "identifier"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "nested_identifier"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "."
	          },
	          {
	            "type": "SYMBOL",
	            "name": "identifier"
	          }
	        ]
	      }
	    },
	    "jsx_namespace_name": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_identifier"
	        },
	        {
	          "type": "STRING",
	          "value": ":"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_identifier"
	        }
	      ]
	    },
	    "_jsx_element_name": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "nested_identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_namespace_name"
	        }
	      ]
	    },
	    "jsx_closing_element": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "<"
	        },
	        {
	          "type": "STRING",
	          "value": "/"
	        },
	        {
	          "type": "FIELD",
	          "name": "name",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_jsx_element_name"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ">"
	        }
	      ]
	    },
	    "jsx_self_closing_element": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "<"
	        },
	        {
	          "type": "FIELD",
	          "name": "name",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_jsx_element_name"
	          }
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "FIELD",
	            "name": "attribute",
	            "content": {
	              "type": "SYMBOL",
	              "name": "_jsx_attribute"
	            }
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "/"
	        },
	        {
	          "type": "STRING",
	          "value": ">"
	        }
	      ]
	    },
	    "_jsx_attribute": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "jsx_attribute"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_expression"
	        }
	      ]
	    },
	    "_jsx_attribute_name": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_jsx_identifier"
	          },
	          "named": true,
	          "value": "property_identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_namespace_name"
	        }
	      ]
	    },
	    "jsx_attribute": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_attribute_name"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "="
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "_jsx_attribute_value"
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "_jsx_attribute_value": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "string"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_jsx_element"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "jsx_fragment"
	        }
	      ]
	    },
	    "class": {
	      "type": "PREC",
	      "value": "literal",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "FIELD",
	              "name": "decorator",
	              "content": {
	                "type": "SYMBOL",
	                "name": "decorator"
	              }
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "class"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                {
	                  "type": "BLANK"
	                }
	              ]
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "class_heritage"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "class_body"
	            }
	          }
	        ]
	      }
	    },
	    "class_declaration": {
	      "type": "PREC",
	      "value": "declaration",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "FIELD",
	              "name": "decorator",
	              "content": {
	                "type": "SYMBOL",
	                "name": "decorator"
	              }
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "class"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "SYMBOL",
	              "name": "identifier"
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "class_heritage"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "class_body"
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_automatic_semicolon"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "class_heritage": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "extends"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "expression"
	        }
	      ]
	    },
	    "function": {
	      "type": "PREC",
	      "value": "literal",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "async"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "function"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                {
	                  "type": "BLANK"
	                }
	              ]
	            }
	          },
	          {
	            "type": "SYMBOL",
	            "name": "_call_signature"
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement_block"
	            }
	          }
	        ]
	      }
	    },
	    "function_declaration": {
	      "type": "PREC_RIGHT",
	      "value": "declaration",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "async"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "function"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "SYMBOL",
	              "name": "identifier"
	            }
	          },
	          {
	            "type": "SYMBOL",
	            "name": "_call_signature"
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement_block"
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_automatic_semicolon"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "generator_function": {
	      "type": "PREC",
	      "value": "literal",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "async"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "function"
	          },
	          {
	            "type": "STRING",
	            "value": "*"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                {
	                  "type": "BLANK"
	                }
	              ]
	            }
	          },
	          {
	            "type": "SYMBOL",
	            "name": "_call_signature"
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement_block"
	            }
	          }
	        ]
	      }
	    },
	    "generator_function_declaration": {
	      "type": "PREC_RIGHT",
	      "value": "declaration",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "async"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "function"
	          },
	          {
	            "type": "STRING",
	            "value": "*"
	          },
	          {
	            "type": "FIELD",
	            "name": "name",
	            "content": {
	              "type": "SYMBOL",
	              "name": "identifier"
	            }
	          },
	          {
	            "type": "SYMBOL",
	            "name": "_call_signature"
	          },
	          {
	            "type": "FIELD",
	            "name": "body",
	            "content": {
	              "type": "SYMBOL",
	              "name": "statement_block"
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_automatic_semicolon"
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "arrow_function": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "async"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "FIELD",
	              "name": "parameter",
	              "content": {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "ALIAS",
	                    "content": {
	                      "type": "SYMBOL",
	                      "name": "_reserved_identifier"
	                    },
	                    "named": true,
	                    "value": "identifier"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "identifier"
	                  }
	                ]
	              }
	            },
	            {
	              "type": "SYMBOL",
	              "name": "_call_signature"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": "=>"
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "expression"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "statement_block"
	              }
	            ]
	          }
	        }
	      ]
	    },
	    "_call_signature": {
	      "type": "FIELD",
	      "name": "parameters",
	      "content": {
	        "type": "SYMBOL",
	        "name": "formal_parameters"
	      }
	    },
	    "_formal_parameter": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "pattern"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "assignment_pattern"
	        }
	      ]
	    },
	    "call_expression": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "PREC",
	          "value": "call",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "function",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "arguments",
	                "content": {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "arguments"
	                    },
	                    {
	                      "type": "SYMBOL",
	                      "name": "template_string"
	                    }
	                  ]
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC",
	          "value": "member",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "function",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "primary_expression"
	                }
	              },
	              {
	                "type": "STRING",
	                "value": "?."
	              },
	              {
	                "type": "FIELD",
	                "name": "arguments",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "arguments"
	                }
	              }
	            ]
	          }
	        }
	      ]
	    },
	    "new_expression": {
	      "type": "PREC_RIGHT",
	      "value": "new",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "new"
	          },
	          {
	            "type": "FIELD",
	            "name": "constructor",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "primary_expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "new_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "arguments",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "PREC_DYNAMIC",
	                  "value": 1,
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "arguments"
	                  }
	                },
	                {
	                  "type": "BLANK"
	                }
	              ]
	            }
	          }
	        ]
	      }
	    },
	    "await_expression": {
	      "type": "PREC",
	      "value": "unary_void",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "await"
	          },
	          {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        ]
	      }
	    },
	    "member_expression": {
	      "type": "PREC",
	      "value": "member",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "object",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "primary_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "."
	              },
	              {
	                "type": "STRING",
	                "value": "?."
	              }
	            ]
	          },
	          {
	            "type": "FIELD",
	            "name": "property",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "private_property_identifier"
	                },
	                {
	                  "type": "ALIAS",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "identifier"
	                  },
	                  "named": true,
	                  "value": "property_identifier"
	                }
	              ]
	            }
	          }
	        ]
	      }
	    },
	    "subscript_expression": {
	      "type": "PREC_RIGHT",
	      "value": "member",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "object",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "primary_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "?."
	              },
	              {
	                "type": "BLANK"
	              }
	            ]
	          },
	          {
	            "type": "STRING",
	            "value": "["
	          },
	          {
	            "type": "FIELD",
	            "name": "index",
	            "content": {
	              "type": "SYMBOL",
	              "name": "_expressions"
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "]"
	          }
	        ]
	      }
	    },
	    "_lhs_expression": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "member_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "subscript_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_identifier"
	        },
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_reserved_identifier"
	          },
	          "named": true,
	          "value": "identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_destructuring_pattern"
	        }
	      ]
	    },
	    "assignment_expression": {
	      "type": "PREC_RIGHT",
	      "value": "assign",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "left",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "parenthesized_expression"
	                },
	                {
	                  "type": "SYMBOL",
	                  "name": "_lhs_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "="
	          },
	          {
	            "type": "FIELD",
	            "name": "right",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          }
	        ]
	      }
	    },
	    "_augmented_assignment_lhs": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "member_expression"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "subscript_expression"
	        },
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_reserved_identifier"
	          },
	          "named": true,
	          "value": "identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "parenthesized_expression"
	        }
	      ]
	    },
	    "augmented_assignment_expression": {
	      "type": "PREC_RIGHT",
	      "value": "assign",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "left",
	            "content": {
	              "type": "SYMBOL",
	              "name": "_augmented_assignment_lhs"
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "operator",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "+="
	                },
	                {
	                  "type": "STRING",
	                  "value": "-="
	                },
	                {
	                  "type": "STRING",
	                  "value": "*="
	                },
	                {
	                  "type": "STRING",
	                  "value": "/="
	                },
	                {
	                  "type": "STRING",
	                  "value": "%="
	                },
	                {
	                  "type": "STRING",
	                  "value": "^="
	                },
	                {
	                  "type": "STRING",
	                  "value": "&="
	                },
	                {
	                  "type": "STRING",
	                  "value": "|="
	                },
	                {
	                  "type": "STRING",
	                  "value": ">>="
	                },
	                {
	                  "type": "STRING",
	                  "value": ">>>="
	                },
	                {
	                  "type": "STRING",
	                  "value": "<<="
	                },
	                {
	                  "type": "STRING",
	                  "value": "**="
	                },
	                {
	                  "type": "STRING",
	                  "value": "&&="
	                },
	                {
	                  "type": "STRING",
	                  "value": "||="
	                },
	                {
	                  "type": "STRING",
	                  "value": "??="
	                }
	              ]
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "right",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          }
	        ]
	      }
	    },
	    "_initializer": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "="
	        },
	        {
	          "type": "FIELD",
	          "name": "value",
	          "content": {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        }
	      ]
	    },
	    "_destructuring_pattern": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "object_pattern"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "array_pattern"
	        }
	      ]
	    },
	    "spread_element": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "..."
	        },
	        {
	          "type": "SYMBOL",
	          "name": "expression"
	        }
	      ]
	    },
	    "ternary_expression": {
	      "type": "PREC_RIGHT",
	      "value": "ternary",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "condition",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          },
	          {
	            "type": "ALIAS",
	            "content": {
	              "type": "SYMBOL",
	              "name": "_ternary_qmark"
	            },
	            "named": false,
	            "value": "?"
	          },
	          {
	            "type": "FIELD",
	            "name": "consequence",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          },
	          {
	            "type": "STRING",
	            "value": ":"
	          },
	          {
	            "type": "FIELD",
	            "name": "alternative",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          }
	        ]
	      }
	    },
	    "binary_expression": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "PREC_LEFT",
	          "value": "logical_and",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "&&"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "logical_or",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "||"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_shift",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": ">>"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_shift",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": ">>>"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_shift",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "<<"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "bitwise_and",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "&"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "bitwise_xor",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "^"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "bitwise_or",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "|"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_plus",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "+"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_plus",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "-"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_times",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "*"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_times",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "/"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_times",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "%"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_exp",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "**"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "<"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "<="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_equality",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "=="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_equality",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "==="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_equality",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "!="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_equality",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "!=="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": ">="
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": ">"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "ternary",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "??"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "instanceof"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        },
	        {
	          "type": "PREC_LEFT",
	          "value": "binary_relation",
	          "content": {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "left",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "STRING",
	                  "value": "in"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "right",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        }
	      ]
	    },
	    "unary_expression": {
	      "type": "PREC_LEFT",
	      "value": "unary_void",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "operator",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "!"
	                },
	                {
	                  "type": "STRING",
	                  "value": "~"
	                },
	                {
	                  "type": "STRING",
	                  "value": "-"
	                },
	                {
	                  "type": "STRING",
	                  "value": "+"
	                },
	                {
	                  "type": "STRING",
	                  "value": "typeof"
	                },
	                {
	                  "type": "STRING",
	                  "value": "void"
	                },
	                {
	                  "type": "STRING",
	                  "value": "delete"
	                }
	              ]
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "argument",
	            "content": {
	              "type": "SYMBOL",
	              "name": "expression"
	            }
	          }
	        ]
	      }
	    },
	    "update_expression": {
	      "type": "PREC_LEFT",
	      "value": 0,
	      "content": {
	        "type": "CHOICE",
	        "members": [
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "argument",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": "++"
	                    },
	                    {
	                      "type": "STRING",
	                      "value": "--"
	                    }
	                  ]
	                }
	              }
	            ]
	          },
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "FIELD",
	                "name": "operator",
	                "content": {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": "++"
	                    },
	                    {
	                      "type": "STRING",
	                      "value": "--"
	                    }
	                  ]
	                }
	              },
	              {
	                "type": "FIELD",
	                "name": "argument",
	                "content": {
	                  "type": "SYMBOL",
	                  "name": "expression"
	                }
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "sequence_expression": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "left",
	          "content": {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ","
	        },
	        {
	          "type": "FIELD",
	          "name": "right",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "sequence_expression"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "expression"
	              }
	            ]
	          }
	        }
	      ]
	    },
	    "string": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "\""
	            },
	            {
	              "type": "REPEAT",
	              "content": {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "ALIAS",
	                    "content": {
	                      "type": "SYMBOL",
	                      "name": "unescaped_double_string_fragment"
	                    },
	                    "named": true,
	                    "value": "string_fragment"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "escape_sequence"
	                  }
	                ]
	              }
	            },
	            {
	              "type": "STRING",
	              "value": "\""
	            }
	          ]
	        },
	        {
	          "type": "SEQ",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "''"
	            },
	            {
	              "type": "REPEAT",
	              "content": {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "ALIAS",
	                    "content": {
	                      "type": "SYMBOL",
	                      "name": "unescaped_single_string_fragment"
	                    },
	                    "named": true,
	                    "value": "string_fragment"
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "escape_sequence"
	                  }
	                ]
	              }
	            },
	            {
	              "type": "STRING",
	              "value": "''"
	            }
	          ]
	        }
	      ]
	    },
	    "unescaped_double_string_fragment": {
	      "type": "IMMEDIATE_TOKEN",
	      "content": {
	        "type": "PREC",
	        "value": 1,
	        "content": {
	          "type": "PATTERN",
	          "value": "[^\"\\\\]+"
	        }
	      }
	    },
	    "unescaped_single_string_fragment": {
	      "type": "IMMEDIATE_TOKEN",
	      "content": {
	        "type": "PREC",
	        "value": 1,
	        "content": {
	          "type": "PATTERN",
	          "value": "[^''\\\\]+"
	        }
	      }
	    },
	    "escape_sequence": {
	      "type": "IMMEDIATE_TOKEN",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "\\"
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "PATTERN",
	                "value": "[^xu0-7]"
	              },
	              {
	                "type": "PATTERN",
	                "value": "[0-7]{1,3}"
	              },
	              {
	                "type": "PATTERN",
	                "value": "x[0-9a-fA-F]{2}"
	              },
	              {
	                "type": "PATTERN",
	                "value": "u[0-9a-fA-F]{4}"
	              },
	              {
	                "type": "PATTERN",
	                "value": "u{[0-9a-fA-F]+}"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "comment": {
	      "type": "TOKEN",
	      "content": {
	        "type": "CHOICE",
	        "members": [
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "//"
	              },
	              {
	                "type": "PATTERN",
	                "value": ".*"
	              }
	            ]
	          },
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "STRING",
	                "value": "/*"
	              },
	              {
	                "type": "PATTERN",
	                "value": "[^*]*\\*+([^/*][^*]*\\*+)*"
	              },
	              {
	                "type": "STRING",
	                "value": "/"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "template_string": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "`"
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "_template_chars"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "escape_sequence"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "template_substitution"
	              }
	            ]
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "`"
	        }
	      ]
	    },
	    "template_substitution": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "${"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "_expressions"
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "regex": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "/"
	        },
	        {
	          "type": "FIELD",
	          "name": "pattern",
	          "content": {
	            "type": "SYMBOL",
	            "name": "regex_pattern"
	          }
	        },
	        {
	          "type": "IMMEDIATE_TOKEN",
	          "content": {
	            "type": "STRING",
	            "value": "/"
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "FIELD",
	              "name": "flags",
	              "content": {
	                "type": "SYMBOL",
	                "name": "regex_flags"
	              }
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "regex_pattern": {
	      "type": "IMMEDIATE_TOKEN",
	      "content": {
	        "type": "PREC",
	        "value": -1,
	        "content": {
	          "type": "REPEAT1",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "["
	                  },
	                  {
	                    "type": "REPEAT",
	                    "content": {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "SEQ",
	                          "members": [
	                            {
	                              "type": "STRING",
	                              "value": "\\"
	                            },
	                            {
	                              "type": "PATTERN",
	                              "value": "."
	                            }
	                          ]
	                        },
	                        {
	                          "type": "PATTERN",
	                          "value": "[^\\]\\n\\\\]"
	                        }
	                      ]
	                    }
	                  },
	                  {
	                    "type": "STRING",
	                    "value": "]"
	                  }
	                ]
	              },
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "\\"
	                  },
	                  {
	                    "type": "PATTERN",
	                    "value": "."
	                  }
	                ]
	              },
	              {
	                "type": "PATTERN",
	                "value": "[^/\\\\\\[\\n]"
	              }
	            ]
	          }
	        }
	      }
	    },
	    "regex_flags": {
	      "type": "IMMEDIATE_TOKEN",
	      "content": {
	        "type": "PATTERN",
	        "value": "[a-z]+"
	      }
	    },
	    "number": {
	      "type": "TOKEN",
	      "content": {
	        "type": "CHOICE",
	        "members": [
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "0x"
	                  },
	                  {
	                    "type": "STRING",
	                    "value": "0X"
	                  }
	                ]
	              },
	              {
	                "type": "PATTERN",
	                "value": "[\\da-fA-F](_?[\\da-fA-F])*"
	              }
	            ]
	          },
	          {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": "0"
	                      },
	                      {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "STRING",
	                                "value": "0"
	                              },
	                              {
	                                "type": "BLANK"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "PATTERN",
	                            "value": "[1-9]"
	                          },
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "SEQ",
	                                "members": [
	                                  {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "STRING",
	                                        "value": "_"
	                                      },
	                                      {
	                                        "type": "BLANK"
	                                      }
	                                    ]
	                                  },
	                                  {
	                                    "type": "PATTERN",
	                                    "value": "\\d(_?\\d)*"
	                                  }
	                                ]
	                              },
	                              {
	                                "type": "BLANK"
	                              }
	                            ]
	                          }
	                        ]
	                      }
	                    ]
	                  },
	                  {
	                    "type": "STRING",
	                    "value": "."
	                  },
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "PATTERN",
	                        "value": "\\d(_?\\d)*"
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "STRING",
	                                "value": "e"
	                              },
	                              {
	                                "type": "STRING",
	                                "value": "E"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "SEQ",
	                            "members": [
	                              {
	                                "type": "CHOICE",
	                                "members": [
	                                  {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "STRING",
	                                        "value": "-"
	                                      },
	                                      {
	                                        "type": "STRING",
	                                        "value": "+"
	                                      }
	                                    ]
	                                  },
	                                  {
	                                    "type": "BLANK"
	                                  }
	                                ]
	                              },
	                              {
	                                "type": "PATTERN",
	                                "value": "\\d(_?\\d)*"
	                              }
	                            ]
	                          }
	                        ]
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  }
	                ]
	              },
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "."
	                  },
	                  {
	                    "type": "PATTERN",
	                    "value": "\\d(_?\\d)*"
	                  },
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "STRING",
	                                "value": "e"
	                              },
	                              {
	                                "type": "STRING",
	                                "value": "E"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "SEQ",
	                            "members": [
	                              {
	                                "type": "CHOICE",
	                                "members": [
	                                  {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "STRING",
	                                        "value": "-"
	                                      },
	                                      {
	                                        "type": "STRING",
	                                        "value": "+"
	                                      }
	                                    ]
	                                  },
	                                  {
	                                    "type": "BLANK"
	                                  }
	                                ]
	                              },
	                              {
	                                "type": "PATTERN",
	                                "value": "\\d(_?\\d)*"
	                              }
	                            ]
	                          }
	                        ]
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  }
	                ]
	              },
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": "0"
	                      },
	                      {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "STRING",
	                                "value": "0"
	                              },
	                              {
	                                "type": "BLANK"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "PATTERN",
	                            "value": "[1-9]"
	                          },
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "SEQ",
	                                "members": [
	                                  {
	                                    "type": "CHOICE",
	                                    "members": [
	                                      {
	                                        "type": "STRING",
	                                        "value": "_"
	                                      },
	                                      {
	                                        "type": "BLANK"
	                                      }
	                                    ]
	                                  },
	                                  {
	                                    "type": "PATTERN",
	                                    "value": "\\d(_?\\d)*"
	                                  }
	                                ]
	                              },
	                              {
	                                "type": "BLANK"
	                              }
	                            ]
	                          }
	                        ]
	                      }
	                    ]
	                  },
	                  {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "STRING",
	                            "value": "e"
	                          },
	                          {
	                            "type": "STRING",
	                            "value": "E"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "CHOICE",
	                                "members": [
	                                  {
	                                    "type": "STRING",
	                                    "value": "-"
	                                  },
	                                  {
	                                    "type": "STRING",
	                                    "value": "+"
	                                  }
	                                ]
	                              },
	                              {
	                                "type": "BLANK"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "PATTERN",
	                            "value": "\\d(_?\\d)*"
	                          }
	                        ]
	                      }
	                    ]
	                  }
	                ]
	              },
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "PATTERN",
	                    "value": "\\d(_?\\d)*"
	                  }
	                ]
	              }
	            ]
	          },
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "0b"
	                  },
	                  {
	                    "type": "STRING",
	                    "value": "0B"
	                  }
	                ]
	              },
	              {
	                "type": "PATTERN",
	                "value": "[0-1](_?[0-1])*"
	              }
	            ]
	          },
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "STRING",
	                    "value": "0o"
	                  },
	                  {
	                    "type": "STRING",
	                    "value": "0O"
	                  }
	                ]
	              },
	              {
	                "type": "PATTERN",
	                "value": "[0-7](_?[0-7])*"
	              }
	            ]
	          },
	          {
	            "type": "SEQ",
	            "members": [
	              {
	                "type": "CHOICE",
	                "members": [
	                  {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "STRING",
	                            "value": "0x"
	                          },
	                          {
	                            "type": "STRING",
	                            "value": "0X"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "PATTERN",
	                        "value": "[\\da-fA-F](_?[\\da-fA-F])*"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "STRING",
	                            "value": "0b"
	                          },
	                          {
	                            "type": "STRING",
	                            "value": "0B"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "PATTERN",
	                        "value": "[0-1](_?[0-1])*"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "STRING",
	                            "value": "0o"
	                          },
	                          {
	                            "type": "STRING",
	                            "value": "0O"
	                          }
	                        ]
	                      },
	                      {
	                        "type": "PATTERN",
	                        "value": "[0-7](_?[0-7])*"
	                      }
	                    ]
	                  },
	                  {
	                    "type": "PATTERN",
	                    "value": "\\d(_?\\d)*"
	                  }
	                ]
	              },
	              {
	                "type": "STRING",
	                "value": "n"
	              }
	            ]
	          }
	        ]
	      }
	    },
	    "_identifier": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "undefined"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "identifier"
	        }
	      ]
	    },
	    "identifier": {
	      "type": "TOKEN",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "PATTERN",
	            "value": "[^\\x00-\\x1F\\s\\p{Zs}0-9:;`\"''@#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}\\uFEFF\\u2060\\u200B]|\\\\u[0-9a-fA-F]{4}|\\\\u\\{[0-9a-fA-F]+\\}"
	          },
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "PATTERN",
	              "value": "[^\\x00-\\x1F\\s\\p{Zs}:;`\"''@#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}\\uFEFF\\u2060\\u200B]|\\\\u[0-9a-fA-F]{4}|\\\\u\\{[0-9a-fA-F]+\\}"
	            }
	          }
	        ]
	      }
	    },
	    "private_property_identifier": {
	      "type": "TOKEN",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "#"
	          },
	          {
	            "type": "PATTERN",
	            "value": "[^\\x00-\\x1F\\s\\p{Zs}0-9:;`\"''@#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}\\uFEFF\\u2060\\u200B]|\\\\u[0-9a-fA-F]{4}|\\\\u\\{[0-9a-fA-F]+\\}"
	          },
	          {
	            "type": "REPEAT",
	            "content": {
	              "type": "PATTERN",
	              "value": "[^\\x00-\\x1F\\s\\p{Zs}:;`\"''@#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}\\uFEFF\\u2060\\u200B]|\\\\u[0-9a-fA-F]{4}|\\\\u\\{[0-9a-fA-F]+\\}"
	            }
	          }
	        ]
	      }
	    },
	    "meta_property": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "new"
	        },
	        {
	          "type": "STRING",
	          "value": "."
	        },
	        {
	          "type": "STRING",
	          "value": "target"
	        }
	      ]
	    },
	    "this": {
	      "type": "STRING",
	      "value": "this"
	    },
	    "super": {
	      "type": "STRING",
	      "value": "super"
	    },
	    "true": {
	      "type": "STRING",
	      "value": "true"
	    },
	    "false": {
	      "type": "STRING",
	      "value": "false"
	    },
	    "null": {
	      "type": "STRING",
	      "value": "null"
	    },
	    "undefined": {
	      "type": "STRING",
	      "value": "undefined"
	    },
	    "arguments": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "("
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "CHOICE",
	                      "members": [
	                        {
	                          "type": "SYMBOL",
	                          "name": "expression"
	                        },
	                        {
	                          "type": "SYMBOL",
	                          "name": "spread_element"
	                        }
	                      ]
	                    },
	                    {
	                      "type": "BLANK"
	                    }
	                  ]
	                },
	                {
	                  "type": "REPEAT",
	                  "content": {
	                    "type": "SEQ",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ","
	                      },
	                      {
	                        "type": "CHOICE",
	                        "members": [
	                          {
	                            "type": "CHOICE",
	                            "members": [
	                              {
	                                "type": "SYMBOL",
	                                "name": "expression"
	                              },
	                              {
	                                "type": "SYMBOL",
	                                "name": "spread_element"
	                              }
	                            ]
	                          },
	                          {
	                            "type": "BLANK"
	                          }
	                        ]
	                      }
	                    ]
	                  }
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": ")"
	        }
	      ]
	    },
	    "decorator": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "@"
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "identifier"
	            },
	            {
	              "type": "ALIAS",
	              "content": {
	                "type": "SYMBOL",
	                "name": "decorator_member_expression"
	              },
	              "named": true,
	              "value": "member_expression"
	            },
	            {
	              "type": "ALIAS",
	              "content": {
	                "type": "SYMBOL",
	                "name": "decorator_call_expression"
	              },
	              "named": true,
	              "value": "call_expression"
	            }
	          ]
	        }
	      ]
	    },
	    "decorator_member_expression": {
	      "type": "PREC",
	      "value": "member",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "object",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                {
	                  "type": "ALIAS",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "decorator_member_expression"
	                  },
	                  "named": true,
	                  "value": "member_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "STRING",
	            "value": "."
	          },
	          {
	            "type": "FIELD",
	            "name": "property",
	            "content": {
	              "type": "ALIAS",
	              "content": {
	                "type": "SYMBOL",
	                "name": "identifier"
	              },
	              "named": true,
	              "value": "property_identifier"
	            }
	          }
	        ]
	      }
	    },
	    "decorator_call_expression": {
	      "type": "PREC",
	      "value": "call",
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "FIELD",
	            "name": "function",
	            "content": {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "SYMBOL",
	                  "name": "identifier"
	                },
	                {
	                  "type": "ALIAS",
	                  "content": {
	                    "type": "SYMBOL",
	                    "name": "decorator_member_expression"
	                  },
	                  "named": true,
	                  "value": "member_expression"
	                }
	              ]
	            }
	          },
	          {
	            "type": "FIELD",
	            "name": "arguments",
	            "content": {
	              "type": "SYMBOL",
	              "name": "arguments"
	            }
	          }
	        ]
	      }
	    },
	    "class_body": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "{"
	        },
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "FIELD",
	                    "name": "member",
	                    "content": {
	                      "type": "SYMBOL",
	                      "name": "method_definition"
	                    }
	                  },
	                  {
	                    "type": "CHOICE",
	                    "members": [
	                      {
	                        "type": "STRING",
	                        "value": ";"
	                      },
	                      {
	                        "type": "BLANK"
	                      }
	                    ]
	                  }
	                ]
	              },
	              {
	                "type": "SEQ",
	                "members": [
	                  {
	                    "type": "FIELD",
	                    "name": "member",
	                    "content": {
	                      "type": "SYMBOL",
	                      "name": "field_definition"
	                    }
	                  },
	                  {
	                    "type": "SYMBOL",
	                    "name": "_semicolon"
	                  }
	                ]
	              }
	            ]
	          }
	        },
	        {
	          "type": "STRING",
	          "value": "}"
	        }
	      ]
	    },
	    "field_definition": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "FIELD",
	            "name": "decorator",
	            "content": {
	              "type": "SYMBOL",
	              "name": "decorator"
	            }
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "static"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "FIELD",
	          "name": "property",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_property_name"
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SYMBOL",
	              "name": "_initializer"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        }
	      ]
	    },
	    "formal_parameters": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "("
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "SEQ",
	              "members": [
	                {
	                  "type": "SEQ",
	                  "members": [
	                    {
	                      "type": "SYMBOL",
	                      "name": "_formal_parameter"
	                    },
	                    {
	                      "type": "REPEAT",
	                      "content": {
	                        "type": "SEQ",
	                        "members": [
	                          {
	                            "type": "STRING",
	                            "value": ","
	                          },
	                          {
	                            "type": "SYMBOL",
	                            "name": "_formal_parameter"
	                          }
	                        ]
	                      }
	                    }
	                  ]
	                },
	                {
	                  "type": "CHOICE",
	                  "members": [
	                    {
	                      "type": "STRING",
	                      "value": ","
	                    },
	                    {
	                      "type": "BLANK"
	                    }
	                  ]
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "STRING",
	          "value": ")"
	        }
	      ]
	    },
	    "pattern": {
	      "type": "PREC_DYNAMIC",
	      "value": -1,
	      "content": {
	        "type": "CHOICE",
	        "members": [
	          {
	            "type": "SYMBOL",
	            "name": "_lhs_expression"
	          },
	          {
	            "type": "SYMBOL",
	            "name": "rest_pattern"
	          }
	        ]
	      }
	    },
	    "rest_pattern": {
	      "type": "PREC_RIGHT",
	      "value": 0,
	      "content": {
	        "type": "SEQ",
	        "members": [
	          {
	            "type": "STRING",
	            "value": "..."
	          },
	          {
	            "type": "SYMBOL",
	            "name": "_lhs_expression"
	          }
	        ]
	      }
	    },
	    "method_definition": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "REPEAT",
	          "content": {
	            "type": "FIELD",
	            "name": "decorator",
	            "content": {
	              "type": "SYMBOL",
	              "name": "decorator"
	            }
	          }
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "static"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "STRING",
	              "value": "async"
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "CHOICE",
	          "members": [
	            {
	              "type": "CHOICE",
	              "members": [
	                {
	                  "type": "STRING",
	                  "value": "get"
	                },
	                {
	                  "type": "STRING",
	                  "value": "set"
	                },
	                {
	                  "type": "STRING",
	                  "value": "*"
	                }
	              ]
	            },
	            {
	              "type": "BLANK"
	            }
	          ]
	        },
	        {
	          "type": "FIELD",
	          "name": "name",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_property_name"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "parameters",
	          "content": {
	            "type": "SYMBOL",
	            "name": "formal_parameters"
	          }
	        },
	        {
	          "type": "FIELD",
	          "name": "body",
	          "content": {
	            "type": "SYMBOL",
	            "name": "statement_block"
	          }
	        }
	      ]
	    },
	    "pair": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "key",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_property_name"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ":"
	        },
	        {
	          "type": "FIELD",
	          "name": "value",
	          "content": {
	            "type": "SYMBOL",
	            "name": "expression"
	          }
	        }
	      ]
	    },
	    "pair_pattern": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "FIELD",
	          "name": "key",
	          "content": {
	            "type": "SYMBOL",
	            "name": "_property_name"
	          }
	        },
	        {
	          "type": "STRING",
	          "value": ":"
	        },
	        {
	          "type": "FIELD",
	          "name": "value",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "pattern"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "assignment_pattern"
	              }
	            ]
	          }
	        }
	      ]
	    },
	    "_property_name": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "ALIAS",
	          "content": {
	            "type": "CHOICE",
	            "members": [
	              {
	                "type": "SYMBOL",
	                "name": "identifier"
	              },
	              {
	                "type": "SYMBOL",
	                "name": "_reserved_identifier"
	              }
	            ]
	          },
	          "named": true,
	          "value": "property_identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "private_property_identifier"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "string"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "number"
	        },
	        {
	          "type": "SYMBOL",
	          "name": "computed_property_name"
	        }
	      ]
	    },
	    "computed_property_name": {
	      "type": "SEQ",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "["
	        },
	        {
	          "type": "SYMBOL",
	          "name": "expression"
	        },
	        {
	          "type": "STRING",
	          "value": "]"
	        }
	      ]
	    },
	    "_reserved_identifier": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "STRING",
	          "value": "get"
	        },
	        {
	          "type": "STRING",
	          "value": "set"
	        },
	        {
	          "type": "STRING",
	          "value": "async"
	        },
	        {
	          "type": "STRING",
	          "value": "static"
	        },
	        {
	          "type": "STRING",
	          "value": "export"
	        }
	      ]
	    },
	    "_semicolon": {
	      "type": "CHOICE",
	      "members": [
	        {
	          "type": "SYMBOL",
	          "name": "_automatic_semicolon"
	        },
	        {
	          "type": "STRING",
	          "value": ";"
	        }
	      ]
	    }
	  },
	  "extras": [
	    {
	      "type": "SYMBOL",
	      "name": "comment"
	    },
	    {
	      "type": "PATTERN",
	      "value": "[\\s\\p{Zs}\\uFEFF\\u2060\\u200B]"
	    }
	  ],
	  "conflicts": [
	    [
	      "primary_expression",
	      "_property_name"
	    ],
	    [
	      "primary_expression",
	      "_property_name",
	      "arrow_function"
	    ],
	    [
	      "primary_expression",
	      "arrow_function"
	    ],
	    [
	      "primary_expression",
	      "method_definition"
	    ],
	    [
	      "primary_expression",
	      "rest_pattern"
	    ],
	    [
	      "primary_expression",
	      "pattern"
	    ],
	    [
	      "primary_expression",
	      "_for_header"
	    ],
	    [
	      "array",
	      "array_pattern"
	    ],
	    [
	      "object",
	      "object_pattern"
	    ],
	    [
	      "assignment_expression",
	      "pattern"
	    ],
	    [
	      "assignment_expression",
	      "object_assignment_pattern"
	    ],
	    [
	      "labeled_statement",
	      "_property_name"
	    ],
	    [
	      "computed_property_name",
	      "array"
	    ],
	    [
	      "binary_expression",
	      "_initializer"
	    ]
	  ],
	  "precedences": [
	    [
	      {
	        "type": "STRING",
	        "value": "member"
	      },
	      {
	        "type": "STRING",
	        "value": "call"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "update_expression"
	      },
	      {
	        "type": "STRING",
	        "value": "unary_void"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_exp"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_times"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_plus"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_shift"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_compare"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_relation"
	      },
	      {
	        "type": "STRING",
	        "value": "binary_equality"
	      },
	      {
	        "type": "STRING",
	        "value": "bitwise_and"
	      },
	      {
	        "type": "STRING",
	        "value": "bitwise_xor"
	      },
	      {
	        "type": "STRING",
	        "value": "bitwise_or"
	      },
	      {
	        "type": "STRING",
	        "value": "logical_and"
	      },
	      {
	        "type": "STRING",
	        "value": "logical_or"
	      },
	      {
	        "type": "STRING",
	        "value": "ternary"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "sequence_expression"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "arrow_function"
	      }
	    ],
	    [
	      {
	        "type": "STRING",
	        "value": "assign"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "primary_expression"
	      }
	    ],
	    [
	      {
	        "type": "STRING",
	        "value": "member"
	      },
	      {
	        "type": "STRING",
	        "value": "new"
	      },
	      {
	        "type": "STRING",
	        "value": "call"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "expression"
	      }
	    ],
	    [
	      {
	        "type": "STRING",
	        "value": "declaration"
	      },
	      {
	        "type": "STRING",
	        "value": "literal"
	      }
	    ],
	    [
	      {
	        "type": "SYMBOL",
	        "name": "primary_expression"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "statement_block"
	      },
	      {
	        "type": "STRING",
	        "value": "object"
	      }
	    ],
	    [
	      {
	        "type": "SYMBOL",
	        "name": "import_statement"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "import"
	      }
	    ],
	    [
	      {
	        "type": "SYMBOL",
	        "name": "export_statement"
	      },
	      {
	        "type": "SYMBOL",
	        "name": "primary_expression"
	      }
	    ]
	  ],
	  "externals": [
	    {
	      "type": "SYMBOL",
	      "name": "_automatic_semicolon"
	    },
	    {
	      "type": "SYMBOL",
	      "name": "_template_chars"
	    },
	    {
	      "type": "SYMBOL",
	      "name": "_ternary_qmark"
	    }
	  ],
	  "inline": [
	    "_call_signature",
	    "_formal_parameter",
	    "statement",
	    "_expressions",
	    "_semicolon",
	    "_identifier",
	    "_reserved_identifier",
	    "_jsx_attribute",
	    "_jsx_element_name",
	    "_jsx_child",
	    "_jsx_element",
	    "_jsx_attribute_name",
	    "_jsx_attribute_value",
	    "_jsx_identifier",
	    "_lhs_expression"
	  ],
	  "supertypes": [
	    "statement",
	    "declaration",
	    "expression",
	    "primary_expression",
	    "pattern"
	  ]
	}
	
	'
		highlight: '; Special identifiers
	;--------------------
	
	([
	    (identifier)
	    (shorthand_property_identifier)
	    (shorthand_property_identifier_pattern)
	 ] @constant
	 (#match? @constant "^[A-Z_][A-Z\\d_]+$"))
	
	
	((identifier) @constructor
	 (#match? @constructor "^[A-Z]"))
	
	((identifier) @variable.builtin
	 (#match? @variable.builtin "^(arguments|module|console|window|document)$")
	 (#is-not? local))
	
	((identifier) @function.builtin
	 (#eq? @function.builtin "require")
	 (#is-not? local))
	
	; Function and method definitions
	;--------------------------------
	
	(function
	  name: (identifier) @function)
	(function_declaration
	  name: (identifier) @function)
	(method_definition
	  name: (property_identifier) @function.method)
	
	(pair
	  key: (property_identifier) @function.method
	  value: [(function) (arrow_function)])
	
	(assignment_expression
	  left: (member_expression
	    property: (property_identifier) @function.method)
	  right: [(function) (arrow_function)])
	
	(variable_declarator
	  name: (identifier) @function
	  value: [(function) (arrow_function)])
	
	(assignment_expression
	  left: (identifier) @function
	  right: [(function) (arrow_function)])
	
	; Function and method calls
	;--------------------------
	
	(call_expression
	  function: (identifier) @function)
	
	(call_expression
	  function: (member_expression
	    property: (property_identifier) @function.method))
	
	; Variables
	;----------
	
	(identifier) @variable
	
	; Properties
	;-----------
	
	(property_identifier) @property
	
	; Literals
	;---------
	
	(this) @variable.builtin
	(super) @variable.builtin
	
	[
	  (true)
	  (false)
	  (null)
	  (undefined)
	] @constant.builtin
	
	(comment) @comment
	
	[
	  (string)
	  (template_string)
	] @string
	
	(regex) @string.special
	(number) @number
	
	; Tokens
	;-------
	
	(template_substitution
	  "${" @punctuation.special
	  "}" @punctuation.special) @embedded
	
	[
	  ";"
	  "?."
	  "."
	  ","
	] @punctuation.delimiter
	
	[
	  "-"
	  "--"
	  "-="
	  "+"
	  "++"
	  "+="
	  "*"
	  "*="
	  "**"
	  "**="
	  "/"
	  "/="
	  "%"
	  "%="
	  "<"
	  "<="
	  "<<"
	  "<<="
	  "="
	  "=="
	  "==="
	  "!"
	  "!="
	  "!=="
	  "=>"
	  ">"
	  ">="
	  ">>"
	  ">>="
	  ">>>"
	  ">>>="
	  "~"
	  "^"
	  "&"
	  "|"
	  "^="
	  "&="
	  "|="
	  "&&"
	  "||"
	  "??"
	  "&&="
	  "||="
	  "??="
	] @operator
	
	[
	  "("
	  ")"
	  "["
	  "]"
	  "{"
	  "}"
	]  @punctuation.bracket
	
	[
	  "as"
	  "async"
	  "await"
	  "break"
	  "case"
	  "catch"
	  "class"
	  "const"
	  "continue"
	  "debugger"
	  "default"
	  "delete"
	  "do"
	  "else"
	  "export"
	  "extends"
	  "finally"
	  "for"
	  "from"
	  "function"
	  "get"
	  "if"
	  "import"
	  "in"
	  "instanceof"
	  "let"
	  "new"
	  "of"
	  "return"
	  "set"
	  "static"
	  "switch"
	  "target"
	  "throw"
	  "try"
	  "typeof"
	  "var"
	  "void"
	  "while"
	  "with"
	  "yield"
	] @keyword
	'
]

{ #category : #languages }
SBMetaBlockFactory class >> json [

	^ SBMetaBlockFactory new
		name: #json
		preprocess: []
		postprocess: [:f |
			f blockInline: {'string_content'}.
			f rootRuleName: 'document']
		grammar: '{
  "name": "json",
  "rules": {
    "document": {
      "type": "SYMBOL",
      "name": "_value"
    },
    "_value": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "object"
        },
        {
          "type": "SYMBOL",
          "name": "array"
        },
        {
          "type": "SYMBOL",
          "name": "number"
        },
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "SYMBOL",
          "name": "true"
        },
        {
          "type": "SYMBOL",
          "name": "false"
        },
        {
          "type": "SYMBOL",
          "name": "null"
        }
      ]
    },
    "object": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "pair"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "pair"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "pair": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "key",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "string"
              },
              {
                "type": "SYMBOL",
                "name": "number"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "_value"
          }
        }
      ]
    },
    "array": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_value"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "_value"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "string": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": "\""
            },
            {
              "type": "STRING",
              "value": "\""
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": "\""
            },
            {
              "type": "SYMBOL",
              "name": "string_content"
            },
            {
              "type": "STRING",
              "value": "\""
            }
          ]
        }
      ]
    },
    "string_content": {
      "type": "REPEAT1",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "IMMEDIATE_TOKEN",
            "content": {
              "type": "PATTERN",
              "value": "[^\\\\\"\\n]+"
            }
          },
          {
            "type": "SYMBOL",
            "name": "escape_sequence"
          }
        ]
      }
    },
    "escape_sequence": {
      "type": "IMMEDIATE_TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "\\"
          },
          {
            "type": "PATTERN",
            "value": "(\\\"|\\\\|\\/|b|f|n|r|t|u)"
          }
        ]
      }
    },
    "number": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0x"
                  },
                  {
                    "type": "STRING",
                    "value": "0X"
                  }
                ]
              },
              {
                "type": "PATTERN",
                "value": "[\\da-fA-F]+"
              }
            ]
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "STRING",
                                "value": "-"
                              },
                              {
                                "type": "STRING",
                                "value": "+"
                              }
                            ]
                          },
                          {
                            "type": "BLANK"
                          }
                        ]
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "STRING",
                            "value": "0"
                          },
                          {
                            "type": "SEQ",
                            "members": [
                              {
                                "type": "PATTERN",
                                "value": "[1-9]"
                              },
                              {
                                "type": "CHOICE",
                                "members": [
                                  {
                                    "type": "PATTERN",
                                    "value": "\\d+"
                                  },
                                  {
                                    "type": "BLANK"
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "type": "STRING",
                    "value": "."
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "\\d+"
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "STRING",
                                "value": "e"
                              },
                              {
                                "type": "STRING",
                                "value": "E"
                              }
                            ]
                          },
                          {
                            "type": "SEQ",
                            "members": [
                              {
                                "type": "CHOICE",
                                "members": [
                                  {
                                    "type": "CHOICE",
                                    "members": [
                                      {
                                        "type": "STRING",
                                        "value": "-"
                                      },
                                      {
                                        "type": "STRING",
                                        "value": "+"
                                      }
                                    ]
                                  },
                                  {
                                    "type": "BLANK"
                                  }
                                ]
                              },
                              {
                                "type": "PATTERN",
                                "value": "\\d+"
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": "."
                  },
                  {
                    "type": "PATTERN",
                    "value": "\\d+"
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "STRING",
                                "value": "e"
                              },
                              {
                                "type": "STRING",
                                "value": "E"
                              }
                            ]
                          },
                          {
                            "type": "SEQ",
                            "members": [
                              {
                                "type": "CHOICE",
                                "members": [
                                  {
                                    "type": "CHOICE",
                                    "members": [
                                      {
                                        "type": "STRING",
                                        "value": "-"
                                      },
                                      {
                                        "type": "STRING",
                                        "value": "+"
                                      }
                                    ]
                                  },
                                  {
                                    "type": "BLANK"
                                  }
                                ]
                              },
                              {
                                "type": "PATTERN",
                                "value": "\\d+"
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "STRING",
                                "value": "-"
                              },
                              {
                                "type": "STRING",
                                "value": "+"
                              }
                            ]
                          },
                          {
                            "type": "BLANK"
                          }
                        ]
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "STRING",
                            "value": "0"
                          },
                          {
                            "type": "SEQ",
                            "members": [
                              {
                                "type": "PATTERN",
                                "value": "[1-9]"
                              },
                              {
                                "type": "CHOICE",
                                "members": [
                                  {
                                    "type": "PATTERN",
                                    "value": "\\d+"
                                  },
                                  {
                                    "type": "BLANK"
                                  }
                                ]
                              }
                            ]
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "STRING",
                                "value": "e"
                              },
                              {
                                "type": "STRING",
                                "value": "E"
                              }
                            ]
                          },
                          {
                            "type": "SEQ",
                            "members": [
                              {
                                "type": "CHOICE",
                                "members": [
                                  {
                                    "type": "CHOICE",
                                    "members": [
                                      {
                                        "type": "STRING",
                                        "value": "-"
                                      },
                                      {
                                        "type": "STRING",
                                        "value": "+"
                                      }
                                    ]
                                  },
                                  {
                                    "type": "BLANK"
                                  }
                                ]
                              },
                              {
                                "type": "PATTERN",
                                "value": "\\d+"
                              }
                            ]
                          }
                        ]
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0b"
                  },
                  {
                    "type": "STRING",
                    "value": "0B"
                  }
                ]
              },
              {
                "type": "PATTERN",
                "value": "[0-1]+"
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0o"
                  },
                  {
                    "type": "STRING",
                    "value": "0O"
                  }
                ]
              },
              {
                "type": "PATTERN",
                "value": "[0-7]+"
              }
            ]
          }
        ]
      }
    },
    "true": {
      "type": "STRING",
      "value": "true"
    },
    "false": {
      "type": "STRING",
      "value": "false"
    },
    "null": {
      "type": "STRING",
      "value": "null"
    }
  },
  "extras": [
    {
      "type": "PATTERN",
      "value": "\\s"
    }
  ],
  "conflicts": [],
  "precedences": [],
  "externals": [],
  "inline": [],
  "supertypes": [
    "_value"
  ]
}

'
		highlight: '(pair
  key: (_) @keyword)

(string) @string

(object
  "{" @escape
  (_)
  "}" @escape)

["true" "false"] @keyword

(number) @number'
]

{ #category : #languages }
SBMetaBlockFactory class >> loadLanguage: aGithubString name: aString [

	| path |
	path := self fetchLibrary: aGithubString language: aString.
	self compileParserIn: path name: aString.
	self generateGrammarMethodFrom: path name: aString.
	self generateFFIMethodFor: aString
]

{ #category : #'block deduplication' }
SBMetaBlockFactory class >> maxRecursionCountOf: aBlock [

	| max maxType |
	" find the maximum number of repeated elements in this block"
	max := 0.
	maxType := nil.
	aBlock allMorphsDo: [:morph |
		morph hasSubmorphs ifFalse: [ | typeCount |
			typeCount := Dictionary new.
			morph allOwnersDo: [:owner | (owner isKindOf: SBInlineBlockSymbol) ifTrue: [typeCount at: owner type put: (typeCount at: owner type ifAbsentPut: [0]) + 1]].
			max := typeCount values max max: max.
			typeCount values max = max ifTrue: [maxType := typeCount associations detectMax: [:m | m value]]]].
	Transcript showln: {aBlock. max. maxType}.
	^ max
]

{ #category : #'block deduplication' }
SBMetaBlockFactory class >> maxSimpleRecursionCountOf: aBlock [

	| typeCount |
	" find the maximum number of repeated elements in this block"
	typeCount := Dictionary new.
	aBlock allMorphsDo: [:morph | (morph isKindOf: SBInlineBlockSymbol) ifTrue: [typeCount at: morph type put: (typeCount at: morph type ifAbsentPut: [0]) + 1]].
	Transcript showln: {aBlock. typeCount associations detectMax: [:assoc | assoc value]}.
	^ typeCount values max
]

{ #category : #languages }
SBMetaBlockFactory class >> python [
	" https://github.com/tree-sitter/tree-sitter-python/blob/master/src/grammar.json "

	^ SBMetaBlockFactory new
		name: #python
		preprocess: [:f |
			(f grammar rules at: 'string')
				type: 'SEQ';
				members: {
					JsonObject fromAssociations: {'type' -> 'SYMBOL'. 'name' -> '"'}.
					JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '.*'}.
					JsonObject fromAssociations: {'type' -> 'SYMBOL'. 'name' -> '"'}}.
			f grammar rules
				at: '_string_content'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '.*'}).
			f grammar rules
				at: '_string_start'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '''|"'}).
			f grammar rules
				at: '_string_end'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '''|"'}).
			(f grammar rules at: '_suite') members: {(f grammar rules at: '_suite') members second}.
			f ignoreExternals: #('_indent' '_dedent' '_newline')]
		postprocess: [:f |
			f statementContainerTypes: #('block' 'module').
			f blockInline: {'expression_statement'. 'parameters'}.
			f rulesDo: [:r | f removeOptionalString: ',' in: r].
			f noteUncapturedText: #('string').
			f rootRuleName: 'module'.
			f delimitedRules: ({'argument_list' -> ','. 'pattern_list' -> ','. 'parameters' -> ','. 'tuple_pattern' -> ','. 'list' -> ','} as: Dictionary).
			f grammar rules at: '"' put: (JsonObject fromAssociations: {
				#type -> 'CHOICE'.
				#members -> {
					JsonObject fromAssociations: {#type -> 'STRING'. #value -> '"'}.
					JsonObject fromAssociations: {#type -> 'STRING'. #value -> ''''}}}).
			f hardLineBreakMatcher: [:b | ((b isKindOf: SBInlineBlockLabel) and: [b label = ':']) and: [(b submorphAfter ifNotNil: #type) ~= 'type']]]
		grammar: '{
  "name": "python",
  "word": "identifier",
  "rules": {
    "module": {
      "type": "REPEAT",
      "content": {
        "type": "SYMBOL",
        "name": "_statement"
      }
    },
    "_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_statements"
        },
        {
          "type": "SYMBOL",
          "name": "_compound_statement"
        }
      ]
    },
    "_simple_statements": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_statement"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_semicolon"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "_simple_statement"
                  }
                ]
              }
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_semicolon"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_newline"
        }
      ]
    },
    "_simple_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "future_import_statement"
        },
        {
          "type": "SYMBOL",
          "name": "import_statement"
        },
        {
          "type": "SYMBOL",
          "name": "import_from_statement"
        },
        {
          "type": "SYMBOL",
          "name": "print_statement"
        },
        {
          "type": "SYMBOL",
          "name": "assert_statement"
        },
        {
          "type": "SYMBOL",
          "name": "expression_statement"
        },
        {
          "type": "SYMBOL",
          "name": "return_statement"
        },
        {
          "type": "SYMBOL",
          "name": "delete_statement"
        },
        {
          "type": "SYMBOL",
          "name": "raise_statement"
        },
        {
          "type": "SYMBOL",
          "name": "pass_statement"
        },
        {
          "type": "SYMBOL",
          "name": "break_statement"
        },
        {
          "type": "SYMBOL",
          "name": "continue_statement"
        },
        {
          "type": "SYMBOL",
          "name": "global_statement"
        },
        {
          "type": "SYMBOL",
          "name": "nonlocal_statement"
        },
        {
          "type": "SYMBOL",
          "name": "exec_statement"
        }
      ]
    },
    "import_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "import"
        },
        {
          "type": "SYMBOL",
          "name": "_import_list"
        }
      ]
    },
    "import_prefix": {
      "type": "REPEAT1",
      "content": {
        "type": "STRING",
        "value": "."
      }
    },
    "relative_import": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "import_prefix"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "dotted_name"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "future_import_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "from"
        },
        {
          "type": "STRING",
          "value": "__future__"
        },
        {
          "type": "STRING",
          "value": "import"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_import_list"
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "("
                },
                {
                  "type": "SYMBOL",
                  "name": "_import_list"
                },
                {
                  "type": "STRING",
                  "value": ")"
                }
              ]
            }
          ]
        }
      ]
    },
    "import_from_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "from"
        },
        {
          "type": "FIELD",
          "name": "module_name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "relative_import"
              },
              {
                "type": "SYMBOL",
                "name": "dotted_name"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": "import"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "wildcard_import"
            },
            {
              "type": "SYMBOL",
              "name": "_import_list"
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "("
                },
                {
                  "type": "SYMBOL",
                  "name": "_import_list"
                },
                {
                  "type": "STRING",
                  "value": ")"
                }
              ]
            }
          ]
        }
      ]
    },
    "_import_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "FIELD",
              "name": "name",
              "content": {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "dotted_name"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "aliased_import"
                  }
                ]
              }
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "FIELD",
                    "name": "name",
                    "content": {
                      "type": "CHOICE",
                      "members": [
                        {
                          "type": "SYMBOL",
                          "name": "dotted_name"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "aliased_import"
                        }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "aliased_import": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "dotted_name"
          }
        },
        {
          "type": "STRING",
          "value": "as"
        },
        {
          "type": "FIELD",
          "name": "alias",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        }
      ]
    },
    "wildcard_import": {
      "type": "STRING",
      "value": "*"
    },
    "print_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC",
          "value": 1,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "print"
              },
              {
                "type": "SYMBOL",
                "name": "chevron"
              },
              {
                "type": "REPEAT",
                "content": {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "FIELD",
                      "name": "argument",
                      "content": {
                        "type": "SYMBOL",
                        "name": "expression"
                      }
                    }
                  ]
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          }
        },
        {
          "type": "PREC",
          "value": -10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "print"
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "argument",
                    "content": {
                      "type": "SYMBOL",
                      "name": "expression"
                    }
                  },
                  {
                    "type": "REPEAT",
                    "content": {
                      "type": "SEQ",
                      "members": [
                        {
                          "type": "STRING",
                          "value": ","
                        },
                        {
                          "type": "FIELD",
                          "name": "argument",
                          "content": {
                            "type": "SYMBOL",
                            "name": "expression"
                          }
                        }
                      ]
                    }
                  }
                ]
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "chevron": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": ">>"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        }
      ]
    },
    "assert_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "assert"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "expression"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "expression"
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    "expression_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "expression"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "expression"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "assignment"
        },
        {
          "type": "SYMBOL",
          "name": "augmented_assignment"
        },
        {
          "type": "SYMBOL",
          "name": "yield"
        }
      ]
    },
    "named_expression": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        },
        {
          "type": "STRING",
          "value": ":="
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        }
      ]
    },
    "return_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "return"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_expressions"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "delete_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "del"
        },
        {
          "type": "SYMBOL",
          "name": "_expressions"
        }
      ]
    },
    "_expressions": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "SYMBOL",
          "name": "expression_list"
        }
      ]
    },
    "raise_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "raise"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_expressions"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "from"
                },
                {
                  "type": "FIELD",
                  "name": "cause",
                  "content": {
                    "type": "SYMBOL",
                    "name": "expression"
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "pass_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "pass"
      }
    },
    "break_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "break"
      }
    },
    "continue_statement": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "STRING",
        "value": "continue"
      }
    },
    "_compound_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "if_statement"
        },
        {
          "type": "SYMBOL",
          "name": "for_statement"
        },
        {
          "type": "SYMBOL",
          "name": "while_statement"
        },
        {
          "type": "SYMBOL",
          "name": "try_statement"
        },
        {
          "type": "SYMBOL",
          "name": "with_statement"
        },
        {
          "type": "SYMBOL",
          "name": "function_definition"
        },
        {
          "type": "SYMBOL",
          "name": "class_definition"
        },
        {
          "type": "SYMBOL",
          "name": "decorated_definition"
        }
      ]
    },
    "if_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "if"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "consequence",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "FIELD",
            "name": "alternative",
            "content": {
              "type": "SYMBOL",
              "name": "elif_clause"
            }
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "FIELD",
              "name": "alternative",
              "content": {
                "type": "SYMBOL",
                "name": "else_clause"
              }
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "elif_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "elif"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "consequence",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        }
      ]
    },
    "else_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "else"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        }
      ]
    },
    "for_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "async"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "for"
        },
        {
          "type": "FIELD",
          "name": "left",
          "content": {
            "type": "SYMBOL",
            "name": "_left_hand_side"
          }
        },
        {
          "type": "STRING",
          "value": "in"
        },
        {
          "type": "FIELD",
          "name": "right",
          "content": {
            "type": "SYMBOL",
            "name": "_expressions"
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        },
        {
          "type": "FIELD",
          "name": "alternative",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "else_clause"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        }
      ]
    },
    "while_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "while"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "FIELD",
              "name": "alternative",
              "content": {
                "type": "SYMBOL",
                "name": "else_clause"
              }
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "try_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "try"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "REPEAT1",
                  "content": {
                    "type": "SYMBOL",
                    "name": "except_clause"
                  }
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "else_clause"
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "finally_clause"
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "SYMBOL",
              "name": "finally_clause"
            }
          ]
        }
      ]
    },
    "except_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "except"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "expression"
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SEQ",
                      "members": [
                        {
                          "type": "CHOICE",
                          "members": [
                            {
                              "type": "STRING",
                              "value": "as"
                            },
                            {
                              "type": "STRING",
                              "value": ","
                            }
                          ]
                        },
                        {
                          "type": "SYMBOL",
                          "name": "expression"
                        }
                      ]
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "_suite"
        }
      ]
    },
    "finally_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "finally"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "SYMBOL",
          "name": "_suite"
        }
      ]
    },
    "with_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "async"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "with"
        },
        {
          "type": "SYMBOL",
          "name": "with_clause"
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        }
      ]
    },
    "with_clause": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "with_item"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "with_item"
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": "("
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "with_item"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "with_item"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "STRING",
              "value": ")"
            }
          ]
        }
      ]
    },
    "with_item": {
      "type": "PREC_DYNAMIC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "value",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": "as"
                  },
                  {
                    "type": "FIELD",
                    "name": "alias",
                    "content": {
                      "type": "SYMBOL",
                      "name": "pattern"
                    }
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "function_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "async"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "def"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        },
        {
          "type": "FIELD",
          "name": "parameters",
          "content": {
            "type": "SYMBOL",
            "name": "parameters"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "->"
                },
                {
                  "type": "FIELD",
                  "name": "return_type",
                  "content": {
                    "type": "SYMBOL",
                    "name": "type"
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        }
      ]
    },
    "parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_parameters"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "lambda_parameters": {
      "type": "SYMBOL",
      "name": "_parameters"
    },
    "list_splat": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "*"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        }
      ]
    },
    "dictionary_splat": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "**"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        }
      ]
    },
    "global_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "global"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "identifier"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "identifier"
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    "nonlocal_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "nonlocal"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "identifier"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "identifier"
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    "exec_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "exec"
        },
        {
          "type": "FIELD",
          "name": "code",
          "content": {
            "type": "SYMBOL",
            "name": "string"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "in"
                },
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "expression"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "expression"
                          }
                        ]
                      }
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "class_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "class"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        },
        {
          "type": "FIELD",
          "name": "superclasses",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_suite"
          }
        }
      ]
    },
    "parenthesized_list_splat": {
      "type": "PREC",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "("
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "ALIAS",
                "content": {
                  "type": "SYMBOL",
                  "name": "parenthesized_list_splat"
                },
                "named": true,
                "value": "parenthesized_expression"
              },
              {
                "type": "SYMBOL",
                "name": "list_splat"
              }
            ]
          },
          {
            "type": "STRING",
            "value": ")"
          }
        ]
      }
    },
    "argument_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "expression"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "list_splat"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "dictionary_splat"
                    },
                    {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "parenthesized_list_splat"
                      },
                      "named": true,
                      "value": "parenthesized_expression"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "keyword_argument"
                    }
                  ]
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "SYMBOL",
                            "name": "expression"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "list_splat"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "dictionary_splat"
                          },
                          {
                            "type": "ALIAS",
                            "content": {
                              "type": "SYMBOL",
                              "name": "parenthesized_list_splat"
                            },
                            "named": true,
                            "value": "parenthesized_expression"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "keyword_argument"
                          }
                        ]
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "decorated_definition": {
      "type": "SEQ",
      "members": [
        {
          "type": "REPEAT1",
          "content": {
            "type": "SYMBOL",
            "name": "decorator"
          }
        },
        {
          "type": "FIELD",
          "name": "definition",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "class_definition"
              },
              {
                "type": "SYMBOL",
                "name": "function_definition"
              }
            ]
          }
        }
      ]
    },
    "decorator": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "@"
        },
        {
          "type": "SYMBOL",
          "name": "primary_expression"
        },
        {
          "type": "SYMBOL",
          "name": "_newline"
        }
      ]
    },
    "_suite": {
      "type": "CHOICE",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_simple_statements"
          },
          "named": true,
          "value": "block"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_indent"
            },
            {
              "type": "SYMBOL",
              "name": "block"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_newline"
          },
          "named": true,
          "value": "block"
        }
      ]
    },
    "block": {
      "type": "SEQ",
      "members": [
        {
          "type": "REPEAT",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_dedent"
        }
      ]
    },
    "expression_list": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "expression"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "SEQ",
                      "members": [
                        {
                          "type": "STRING",
                          "value": ","
                        },
                        {
                          "type": "SYMBOL",
                          "name": "expression"
                        }
                      ]
                    }
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    },
    "dotted_name": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": "."
              },
              {
                "type": "SYMBOL",
                "name": "identifier"
              }
            ]
          }
        }
      ]
    },
    "_parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "parameter"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "parameter"
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "_patterns": {
      "type": "SEQ",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "pattern"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "pattern"
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "parameter": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "typed_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "default_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "typed_default_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "list_splat_pattern"
        },
        {
          "type": "SYMBOL",
          "name": "tuple_pattern"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "STRING",
            "value": "*"
          },
          "named": true,
          "value": "list_splat_pattern"
        },
        {
          "type": "SYMBOL",
          "name": "dictionary_splat_pattern"
        }
      ]
    },
    "pattern": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "keyword_identifier"
        },
        {
          "type": "SYMBOL",
          "name": "subscript"
        },
        {
          "type": "SYMBOL",
          "name": "attribute"
        },
        {
          "type": "SYMBOL",
          "name": "list_splat_pattern"
        },
        {
          "type": "SYMBOL",
          "name": "tuple_pattern"
        },
        {
          "type": "SYMBOL",
          "name": "list_pattern"
        }
      ]
    },
    "tuple_pattern": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_patterns"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "list_pattern": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_patterns"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "default_parameter": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        },
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        }
      ]
    },
    "typed_default_parameter": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "name",
            "content": {
              "type": "SYMBOL",
              "name": "identifier"
            }
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "FIELD",
            "name": "type",
            "content": {
              "type": "SYMBOL",
              "name": "type"
            }
          },
          {
            "type": "STRING",
            "value": "="
          },
          {
            "type": "FIELD",
            "name": "value",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          }
        ]
      }
    },
    "list_splat_pattern": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "*"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "identifier"
            },
            {
              "type": "SYMBOL",
              "name": "keyword_identifier"
            },
            {
              "type": "SYMBOL",
              "name": "subscript"
            },
            {
              "type": "SYMBOL",
              "name": "attribute"
            }
          ]
        }
      ]
    },
    "dictionary_splat_pattern": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "**"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "identifier"
            },
            {
              "type": "SYMBOL",
              "name": "keyword_identifier"
            },
            {
              "type": "SYMBOL",
              "name": "subscript"
            },
            {
              "type": "SYMBOL",
              "name": "attribute"
            }
          ]
        }
      ]
    },
    "_expression_within_for_in_clause": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "lambda_within_for_in_clause"
          },
          "named": true,
          "value": "lambda"
        }
      ]
    },
    "expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "comparison_operator"
        },
        {
          "type": "SYMBOL",
          "name": "not_operator"
        },
        {
          "type": "SYMBOL",
          "name": "boolean_operator"
        },
        {
          "type": "SYMBOL",
          "name": "await"
        },
        {
          "type": "SYMBOL",
          "name": "lambda"
        },
        {
          "type": "SYMBOL",
          "name": "primary_expression"
        },
        {
          "type": "SYMBOL",
          "name": "conditional_expression"
        },
        {
          "type": "SYMBOL",
          "name": "named_expression"
        }
      ]
    },
    "primary_expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "binary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "keyword_identifier"
        },
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "SYMBOL",
          "name": "concatenated_string"
        },
        {
          "type": "SYMBOL",
          "name": "integer"
        },
        {
          "type": "SYMBOL",
          "name": "float"
        },
        {
          "type": "SYMBOL",
          "name": "true"
        },
        {
          "type": "SYMBOL",
          "name": "false"
        },
        {
          "type": "SYMBOL",
          "name": "none"
        },
        {
          "type": "SYMBOL",
          "name": "unary_operator"
        },
        {
          "type": "SYMBOL",
          "name": "attribute"
        },
        {
          "type": "SYMBOL",
          "name": "subscript"
        },
        {
          "type": "SYMBOL",
          "name": "call"
        },
        {
          "type": "SYMBOL",
          "name": "list"
        },
        {
          "type": "SYMBOL",
          "name": "list_comprehension"
        },
        {
          "type": "SYMBOL",
          "name": "dictionary"
        },
        {
          "type": "SYMBOL",
          "name": "dictionary_comprehension"
        },
        {
          "type": "SYMBOL",
          "name": "set"
        },
        {
          "type": "SYMBOL",
          "name": "set_comprehension"
        },
        {
          "type": "SYMBOL",
          "name": "tuple"
        },
        {
          "type": "SYMBOL",
          "name": "parenthesized_expression"
        },
        {
          "type": "SYMBOL",
          "name": "generator_expression"
        },
        {
          "type": "SYMBOL",
          "name": "ellipsis"
        }
      ]
    },
    "not_operator": {
      "type": "PREC",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "not"
          },
          {
            "type": "FIELD",
            "name": "argument",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          }
        ]
      }
    },
    "boolean_operator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC_LEFT",
          "value": 11,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "and"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "or"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "expression"
                }
              }
            ]
          }
        }
      ]
    },
    "binary_operator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC_LEFT",
          "value": 16,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "+"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 16,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "-"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 17,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "*"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 17,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "@"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 17,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "/"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 17,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "%"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 17,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "//"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 19,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "**"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 12,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "|"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 13,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "&"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 14,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "^"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 15,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "<<"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 15,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": ">>"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              }
            ]
          }
        }
      ]
    },
    "unary_operator": {
      "type": "PREC",
      "value": 18,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "+"
                },
                {
                  "type": "STRING",
                  "value": "-"
                },
                {
                  "type": "STRING",
                  "value": "~"
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "argument",
            "content": {
              "type": "SYMBOL",
              "name": "primary_expression"
            }
          }
        ]
      }
    },
    "comparison_operator": {
      "type": "PREC_LEFT",
      "value": 2,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "primary_expression"
          },
          {
            "type": "REPEAT1",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "FIELD",
                  "name": "operators",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "STRING",
                        "value": "<"
                      },
                      {
                        "type": "STRING",
                        "value": "<="
                      },
                      {
                        "type": "STRING",
                        "value": "=="
                      },
                      {
                        "type": "STRING",
                        "value": "!="
                      },
                      {
                        "type": "STRING",
                        "value": ">="
                      },
                      {
                        "type": "STRING",
                        "value": ">"
                      },
                      {
                        "type": "STRING",
                        "value": "<>"
                      },
                      {
                        "type": "STRING",
                        "value": "in"
                      },
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": "not"
                          },
                          {
                            "type": "STRING",
                            "value": "in"
                          }
                        ]
                      },
                      {
                        "type": "STRING",
                        "value": "is"
                      },
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": "is"
                          },
                          {
                            "type": "STRING",
                            "value": "not"
                          }
                        ]
                      }
                    ]
                  }
                },
                {
                  "type": "SYMBOL",
                  "name": "primary_expression"
                }
              ]
            }
          }
        ]
      }
    },
    "lambda": {
      "type": "PREC",
      "value": -2,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "lambda"
          },
          {
            "type": "FIELD",
            "name": "parameters",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "lambda_parameters"
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          }
        ]
      }
    },
    "lambda_within_for_in_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "lambda"
        },
        {
          "type": "FIELD",
          "name": "parameters",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "lambda_parameters"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "_expression_within_for_in_clause"
          }
        }
      ]
    },
    "assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "left",
          "content": {
            "type": "SYMBOL",
            "name": "_left_hand_side"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "="
                },
                {
                  "type": "FIELD",
                  "name": "right",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_right_hand_side"
                  }
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ":"
                },
                {
                  "type": "FIELD",
                  "name": "type",
                  "content": {
                    "type": "SYMBOL",
                    "name": "type"
                  }
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ":"
                },
                {
                  "type": "FIELD",
                  "name": "type",
                  "content": {
                    "type": "SYMBOL",
                    "name": "type"
                  }
                },
                {
                  "type": "STRING",
                  "value": "="
                },
                {
                  "type": "FIELD",
                  "name": "right",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_right_hand_side"
                  }
                }
              ]
            }
          ]
        }
      ]
    },
    "augmented_assignment": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "left",
          "content": {
            "type": "SYMBOL",
            "name": "_left_hand_side"
          }
        },
        {
          "type": "FIELD",
          "name": "operator",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "+="
              },
              {
                "type": "STRING",
                "value": "-="
              },
              {
                "type": "STRING",
                "value": "*="
              },
              {
                "type": "STRING",
                "value": "/="
              },
              {
                "type": "STRING",
                "value": "@="
              },
              {
                "type": "STRING",
                "value": "//="
              },
              {
                "type": "STRING",
                "value": "%="
              },
              {
                "type": "STRING",
                "value": "**="
              },
              {
                "type": "STRING",
                "value": ">>="
              },
              {
                "type": "STRING",
                "value": "<<="
              },
              {
                "type": "STRING",
                "value": "&="
              },
              {
                "type": "STRING",
                "value": "^="
              },
              {
                "type": "STRING",
                "value": "|="
              }
            ]
          }
        },
        {
          "type": "FIELD",
          "name": "right",
          "content": {
            "type": "SYMBOL",
            "name": "_right_hand_side"
          }
        }
      ]
    },
    "_left_hand_side": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "pattern"
        },
        {
          "type": "SYMBOL",
          "name": "pattern_list"
        }
      ]
    },
    "pattern_list": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "pattern"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "REPEAT1",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "pattern"
                      }
                    ]
                  }
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "_right_hand_side": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "SYMBOL",
          "name": "expression_list"
        },
        {
          "type": "SYMBOL",
          "name": "assignment"
        },
        {
          "type": "SYMBOL",
          "name": "augmented_assignment"
        },
        {
          "type": "SYMBOL",
          "name": "yield"
        }
      ]
    },
    "yield": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "yield"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": "from"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "expression"
                  }
                ]
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_expressions"
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          }
        ]
      }
    },
    "attribute": {
      "type": "PREC",
      "value": 20,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "object",
            "content": {
              "type": "SYMBOL",
              "name": "primary_expression"
            }
          },
          {
            "type": "STRING",
            "value": "."
          },
          {
            "type": "FIELD",
            "name": "attribute",
            "content": {
              "type": "SYMBOL",
              "name": "identifier"
            }
          }
        ]
      }
    },
    "subscript": {
      "type": "PREC",
      "value": 20,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "value",
            "content": {
              "type": "SYMBOL",
              "name": "primary_expression"
            }
          },
          {
            "type": "STRING",
            "value": "["
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "subscript",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "expression"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "slice"
                    }
                  ]
                }
              },
              {
                "type": "REPEAT",
                "content": {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "FIELD",
                      "name": "subscript",
                      "content": {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "SYMBOL",
                            "name": "expression"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "slice"
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "BLANK"
              }
            ]
          },
          {
            "type": "STRING",
            "value": "]"
          }
        ]
      }
    },
    "slice": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "expression"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "expression"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ":"
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "expression"
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "ellipsis": {
      "type": "STRING",
      "value": "..."
    },
    "call": {
      "type": "PREC",
      "value": 20,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "function",
            "content": {
              "type": "SYMBOL",
              "name": "primary_expression"
            }
          },
          {
            "type": "FIELD",
            "name": "arguments",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "generator_expression"
                },
                {
                  "type": "SYMBOL",
                  "name": "argument_list"
                }
              ]
            }
          }
        ]
      }
    },
    "typed_parameter": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "identifier"
              },
              {
                "type": "SYMBOL",
                "name": "list_splat_pattern"
              },
              {
                "type": "SYMBOL",
                "name": "dictionary_splat_pattern"
              }
            ]
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "FIELD",
            "name": "type",
            "content": {
              "type": "SYMBOL",
              "name": "type"
            }
          }
        ]
      }
    },
    "type": {
      "type": "SYMBOL",
      "name": "expression"
    },
    "keyword_argument": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "identifier"
              },
              {
                "type": "SYMBOL",
                "name": "keyword_identifier"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        }
      ]
    },
    "list": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_collection_elements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "set": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "SYMBOL",
          "name": "_collection_elements"
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "tuple": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_collection_elements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "dictionary": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "pair"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "dictionary_splat"
                    }
                  ]
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "CHOICE",
                        "members": [
                          {
                            "type": "SYMBOL",
                            "name": "pair"
                          },
                          {
                            "type": "SYMBOL",
                            "name": "dictionary_splat"
                          }
                        ]
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "pair": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "key",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        }
      ]
    },
    "list_comprehension": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_comprehension_clauses"
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "dictionary_comprehension": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "pair"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_comprehension_clauses"
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "set_comprehension": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_comprehension_clauses"
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "generator_expression": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "expression"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_comprehension_clauses"
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "_comprehension_clauses": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "for_in_clause"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "for_in_clause"
              },
              {
                "type": "SYMBOL",
                "name": "if_clause"
              }
            ]
          }
        }
      ]
    },
    "parenthesized_expression": {
      "type": "PREC",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "("
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "expression"
              },
              {
                "type": "SYMBOL",
                "name": "yield"
              }
            ]
          },
          {
            "type": "STRING",
            "value": ")"
          }
        ]
      }
    },
    "_collection_elements": {
      "type": "SEQ",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "expression"
                },
                {
                  "type": "SYMBOL",
                  "name": "yield"
                },
                {
                  "type": "SYMBOL",
                  "name": "list_splat"
                },
                {
                  "type": "SYMBOL",
                  "name": "parenthesized_list_splat"
                }
              ]
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "expression"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "yield"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "list_splat"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "parenthesized_list_splat"
                      }
                    ]
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": ","
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "for_in_clause": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "async"
              },
              {
                "type": "BLANK"
              }
            ]
          },
          {
            "type": "STRING",
            "value": "for"
          },
          {
            "type": "FIELD",
            "name": "left",
            "content": {
              "type": "SYMBOL",
              "name": "_left_hand_side"
            }
          },
          {
            "type": "STRING",
            "value": "in"
          },
          {
            "type": "FIELD",
            "name": "right",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_expression_within_for_in_clause"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "_expression_within_for_in_clause"
                      }
                    ]
                  }
                }
              ]
            }
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "if_clause": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "if"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        }
      ]
    },
    "conditional_expression": {
      "type": "PREC_RIGHT",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "expression"
          },
          {
            "type": "STRING",
            "value": "if"
          },
          {
            "type": "SYMBOL",
            "name": "expression"
          },
          {
            "type": "STRING",
            "value": "else"
          },
          {
            "type": "SYMBOL",
            "name": "expression"
          }
        ]
      }
    },
    "concatenated_string": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "REPEAT1",
          "content": {
            "type": "SYMBOL",
            "name": "string"
          }
        }
      ]
    },
    "string": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_start"
          },
          "named": false,
          "value": "\""
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "interpolation"
              },
              {
                "type": "SYMBOL",
                "name": "escape_sequence"
              },
              {
                "type": "SYMBOL",
                "name": "_not_escape_sequence"
              },
              {
                "type": "SYMBOL",
                "name": "_string_content"
              }
            ]
          }
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "\""
        }
      ]
    },
    "interpolation": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "type_conversion"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "format_specifier"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "escape_sequence": {
      "type": "TOKEN",
      "content": {
        "type": "PREC",
        "value": 1,
        "content": {
          "type": "SEQ",
          "members": [
            {
              "type": "STRING",
              "value": "\\"
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "PATTERN",
                  "value": "u[a-fA-F\\d]{4}"
                },
                {
                  "type": "PATTERN",
                  "value": "U[a-fA-F\\d]{8}"
                },
                {
                  "type": "PATTERN",
                  "value": "x[a-fA-F\\d]{2}"
                },
                {
                  "type": "PATTERN",
                  "value": "\\d{3}"
                },
                {
                  "type": "PATTERN",
                  "value": "\\r?\\n"
                },
                {
                  "type": "PATTERN",
                  "value": "[''\"abfrntv\\\\]"
                }
              ]
            }
          ]
        }
      }
    },
    "_not_escape_sequence": {
      "type": "STRING",
      "value": "\\"
    },
    "format_specifier": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": ":"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "TOKEN",
                "content": {
                  "type": "PREC",
                  "value": 1,
                  "content": {
                    "type": "PATTERN",
                    "value": "[^{}\\n]+"
                  }
                }
              },
              {
                "type": "SYMBOL",
                "name": "format_expression"
              }
            ]
          }
        }
      ]
    },
    "format_expression": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "SYMBOL",
          "name": "expression"
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "type_conversion": {
      "type": "PATTERN",
      "value": "![a-z]"
    },
    "integer": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0x"
                  },
                  {
                    "type": "STRING",
                    "value": "0X"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[A-Fa-f0-9]+"
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "PATTERN",
                    "value": "[Ll]"
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0o"
                  },
                  {
                    "type": "STRING",
                    "value": "0O"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[0-7]+"
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "PATTERN",
                    "value": "[Ll]"
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "STRING",
                    "value": "0b"
                  },
                  {
                    "type": "STRING",
                    "value": "0B"
                  }
                ]
              },
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "_?[0-1]+"
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "PATTERN",
                    "value": "[Ll]"
                  },
                  {
                    "type": "BLANK"
                  }
                ]
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "REPEAT1",
                "content": {
                  "type": "PATTERN",
                  "value": "[0-9]+_?"
                }
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[Ll]"
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[jJ]"
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    },
    "float": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  },
                  {
                    "type": "STRING",
                    "value": "."
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "REPEAT1",
                        "content": {
                          "type": "PATTERN",
                          "value": "[0-9]+_?"
                        }
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "PATTERN",
                            "value": "[eE][\\+-]?"
                          },
                          {
                            "type": "REPEAT1",
                            "content": {
                              "type": "PATTERN",
                              "value": "[0-9]+_?"
                            }
                          }
                        ]
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "REPEAT1",
                        "content": {
                          "type": "PATTERN",
                          "value": "[0-9]+_?"
                        }
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  },
                  {
                    "type": "STRING",
                    "value": "."
                  },
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  },
                  {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "PATTERN",
                            "value": "[eE][\\+-]?"
                          },
                          {
                            "type": "REPEAT1",
                            "content": {
                              "type": "PATTERN",
                              "value": "[0-9]+_?"
                            }
                          }
                        ]
                      },
                      {
                        "type": "BLANK"
                      }
                    ]
                  }
                ]
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "REPEAT1",
                    "content": {
                      "type": "PATTERN",
                      "value": "[0-9]+_?"
                    }
                  },
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[eE][\\+-]?"
                      },
                      {
                        "type": "REPEAT1",
                        "content": {
                          "type": "PATTERN",
                          "value": "[0-9]+_?"
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "PATTERN",
                    "value": "[Ll]"
                  },
                  {
                    "type": "PATTERN",
                    "value": "[jJ]"
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "identifier": {
      "type": "PATTERN",
      "value": "[_\\p{XID_Start}][_\\p{XID_Continue}]*"
    },
    "keyword_identifier": {
      "type": "PREC",
      "value": -3,
      "content": {
        "type": "ALIAS",
        "content": {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "print"
            },
            {
              "type": "STRING",
              "value": "exec"
            },
            {
              "type": "STRING",
              "value": "async"
            },
            {
              "type": "STRING",
              "value": "await"
            }
          ]
        },
        "named": true,
        "value": "identifier"
      }
    },
    "true": {
      "type": "STRING",
      "value": "True"
    },
    "false": {
      "type": "STRING",
      "value": "False"
    },
    "none": {
      "type": "STRING",
      "value": "None"
    },
    "await": {
      "type": "PREC",
      "value": 18,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "await"
          },
          {
            "type": "SYMBOL",
            "name": "expression"
          }
        ]
      }
    },
    "comment": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "#"
          },
          {
            "type": "PATTERN",
            "value": ".*"
          }
        ]
      }
    },
    "_semicolon": {
      "type": "STRING",
      "value": ";"
    }
  },
  "extras": [
    {
      "type": "SYMBOL",
      "name": "comment"
    },
    {
      "type": "PATTERN",
      "value": "[\\s\\f\\uFEFF\\u2060\\u200B]|\\\\\\r?\\n"
    }
  ],
  "conflicts": [
    [
      "primary_expression",
      "pattern"
    ],
    [
      "primary_expression",
      "list_splat_pattern"
    ],
    [
      "tuple",
      "tuple_pattern"
    ],
    [
      "list",
      "list_pattern"
    ],
    [
      "with_item",
      "_collection_elements"
    ]
  ],
  "precedences": [],
  "externals": [
    {
      "type": "SYMBOL",
      "name": "_newline"
    },
    {
      "type": "SYMBOL",
      "name": "_indent"
    },
    {
      "type": "SYMBOL",
      "name": "_dedent"
    },
    {
      "type": "SYMBOL",
      "name": "_string_start"
    },
    {
      "type": "SYMBOL",
      "name": "_string_content"
    },
    {
      "type": "SYMBOL",
      "name": "_string_end"
    }
  ],
  "inline": [
    "_simple_statement",
    "_compound_statement",
    "_suite",
    "_expressions",
    "_left_hand_side",
    "keyword_identifier"
  ],
  "supertypes": [
    "_simple_statement",
    "_compound_statement",
    "expression",
    "primary_expression",
    "pattern",
    "parameter"
  ]
}'
		highlight: '; Identifier naming conventions

((identifier) @constructor
 (#match? @constructor "^[A-Z]"))

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z_]*$"))

; Builtin functions

((call
  function: (identifier) @function.builtin)
 (#match?
   @function.builtin
   "^(abs|all|any|ascii|bin|bool|breakpoint|bytearray|bytes|callable|chr|classmethod|compile|complex|delattr|dict|dir|divmod|enumerate|eval|exec|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|isinstance|issubclass|iter|len|list|locals|map|max|memoryview|min|next|object|oct|open|ord|pow|print|property|range|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|vars|zip|__import__)$"))

; Function calls

(decorator) @function

(call
  function: (attribute attribute: (identifier) @function.method))
(call
  function: (identifier) @function)

; Function definitions

(function_definition
  name: (identifier) @function)

(identifier) @variable
(attribute attribute: (identifier) @property)
(type (identifier) @type)

; Literals

[
  (none)
  (true)
  (false)
] @constant.builtin

[
  (integer)
  (float)
] @number

(comment) @comment
(string) @string
(escape_sequence) @escape

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @embedded

[
  "-"
  "-="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "%"
  "%="
  "^"
  "+"
  "->"
  "+="
  "<"
  "<<"
  "<="
  "<>"
  "="
  ":="
  "=="
  ">"
  ">="
  ">>"
  "|"
  "~"
  "and"
  "in"
  "is"
  "not"
  "or"
] @operator

[
  "as"
  "assert"
  "async"
  "await"
  "break"
  "class"
  "continue"
  "def"
  "del"
  "elif"
  "else"
  "except"
  "exec"
  "finally"
  "for"
  "from"
  "global"
  "if"
  "import"
  "lambda"
  "nonlocal"
  "pass"
  "print"
  "raise"
  "return"
  "try"
  "while"
  "with"
  "yield"
] @keyword'
]

{ #category : #'block deduplication' }
SBMetaBlockFactory class >> removeDuplicateChoices: aCollection [

	aCollection size = 1 ifTrue: [^ aCollection].
	
	SBToggledCode comment: '' active: 1 do: {
		[ | min |
			min := aCollection detectMin: [:m | self maxRecursionCountOf: m].
			^ aCollection select: [:m | (self maxRecursionCountOf: m) = (self maxRecursionCountOf: min)]].
		[ | shortest |
			shortest := aCollection detectMin: [:choice | choice lengthOfLeftMostPath].
			^ aCollection select: [:choice |
				choice = shortest or: [ | a b |
					a := choice leftMostRule ownerThatIsA: SBInlineBlockSymbol.
					b := shortest leftMostRule ownerThatIsA: SBInlineBlockSymbol.
					a notNil and: [b notNil and: [a type ~= b type]]]]]}
]

{ #category : #languages }
SBMetaBlockFactory class >> ruby [

	^ SBMetaBlockFactory new
		name: 'ruby'
		preprocess: [:f |
			f statementContainerTypes: #('program' 'do_block').
			f grammar rules
				at: '_line_break'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> String cr}).
			f grammar rules
				at: 'heredoc_end'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> 'end'}).
			f grammar rules
				at: 'heredoc_content'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> 'content'}).
			f grammar rules
				at: 'heredoc_beginning'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> 'begin'}).
			f grammar rules
				at: '_heredoc_body_start'
				put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> 'start'}).
			f grammar rules
				at: 'hash_key_symbol'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '[A-Za-z0-9_]+\:'}).
			f grammar rules
				at: 'string_content'
				put: (JsonObject fromAssociations: {'type' -> 'PATTERN'. 'value' -> '.*'}).
			f grammar rules at: 'simple_symbol' put: (JsonObject fromAssociations: {
				'type' -> 'SEQ'.
				'members' -> {
					JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> ':'}.
					JsonObject fromAssociations: {'type' -> 'SYMBOL'. 'value' -> 'identifier'}}})]
		postprocess: [:f | ]
		grammar: '{
  "name": "ruby",
  "word": "identifier",
  "rules": {
    "program": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "__END__"
                },
                {
                  "type": "SYMBOL",
                  "name": "_line_break"
                },
                {
                  "type": "SYMBOL",
                  "name": "uninterpreted"
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "uninterpreted": {
      "type": "PATTERN",
      "value": "(.|\\s)*"
    },
    "_statements": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "REPEAT1",
              "content": {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_statement"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "_terminator"
                      }
                    ]
                  },
                  {
                    "type": "SYMBOL",
                    "name": "empty_statement"
                  }
                ]
              }
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_statement"
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_statement"
        }
      ]
    },
    "begin_block": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "BEGIN"
        },
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "end_block": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "END"
        },
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "_statement": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "undef"
        },
        {
          "type": "SYMBOL",
          "name": "alias"
        },
        {
          "type": "SYMBOL",
          "name": "if_modifier"
        },
        {
          "type": "SYMBOL",
          "name": "unless_modifier"
        },
        {
          "type": "SYMBOL",
          "name": "while_modifier"
        },
        {
          "type": "SYMBOL",
          "name": "until_modifier"
        },
        {
          "type": "SYMBOL",
          "name": "rescue_modifier"
        },
        {
          "type": "SYMBOL",
          "name": "begin_block"
        },
        {
          "type": "SYMBOL",
          "name": "end_block"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "method": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "def"
        },
        {
          "type": "SYMBOL",
          "name": "_method_rest"
        }
      ]
    },
    "singleton_method": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "def"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "FIELD",
                  "name": "object",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_variable"
                  }
                },
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "("
                    },
                    {
                      "type": "FIELD",
                      "name": "object",
                      "content": {
                        "type": "SYMBOL",
                        "name": "_arg"
                      }
                    },
                    {
                      "type": "STRING",
                      "value": ")"
                    }
                  ]
                }
              ]
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "."
                },
                {
                  "type": "STRING",
                  "value": "::"
                }
              ]
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_method_rest"
        }
      ]
    },
    "_method_rest": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "_method_name"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_body_expr"
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "FIELD",
                  "name": "parameters",
                  "content": {
                    "type": "ALIAS",
                    "content": {
                      "type": "SYMBOL",
                      "name": "parameters"
                    },
                    "named": true,
                    "value": "method_parameters"
                  }
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SEQ",
                      "members": [
                        {
                          "type": "CHOICE",
                          "members": [
                            {
                              "type": "SYMBOL",
                              "name": "_terminator"
                            },
                            {
                              "type": "BLANK"
                            }
                          ]
                        },
                        {
                          "type": "SYMBOL",
                          "name": "_body_statement"
                        }
                      ]
                    },
                    {
                      "type": "SYMBOL",
                      "name": "_body_expr"
                    }
                  ]
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "FIELD",
                      "name": "parameters",
                      "content": {
                        "type": "ALIAS",
                        "content": {
                          "type": "SYMBOL",
                          "name": "bare_parameters"
                        },
                        "named": true,
                        "value": "method_parameters"
                      }
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                },
                {
                  "type": "SYMBOL",
                  "name": "_terminator"
                },
                {
                  "type": "SYMBOL",
                  "name": "_body_statement"
                }
              ]
            }
          ]
        }
      ]
    },
    "rescue_modifier_arg": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          },
          {
            "type": "STRING",
            "value": "rescue"
          },
          {
            "type": "FIELD",
            "name": "handler",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          }
        ]
      }
    },
    "_body_expr": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "="
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_arg"
            },
            {
              "type": "ALIAS",
              "content": {
                "type": "SYMBOL",
                "name": "rescue_modifier_arg"
              },
              "named": true,
              "value": "rescue_modifier"
            }
          ]
        }
      ]
    },
    "parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_formal_parameter"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "STRING",
                        "value": ","
                      },
                      {
                        "type": "SYMBOL",
                        "name": "_formal_parameter"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "bare_parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_formal_parameter"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "SYMBOL",
                "name": "_formal_parameter"
              }
            ]
          }
        }
      ]
    },
    "block_parameters": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "|"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_formal_parameter"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "_formal_parameter"
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "BLANK"
                }
              ]
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ";"
                },
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "identifier"
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "SYMBOL",
                            "name": "identifier"
                          }
                        ]
                      }
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "|"
        }
      ]
    },
    "_formal_parameter": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_simple_formal_parameter"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "parameters"
          },
          "named": true,
          "value": "destructured_parameter"
        }
      ]
    },
    "_simple_formal_parameter": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "splat_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "hash_splat_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "forward_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "block_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "keyword_parameter"
        },
        {
          "type": "SYMBOL",
          "name": "optional_parameter"
        }
      ]
    },
    "forward_parameter": {
      "type": "STRING",
      "value": "..."
    },
    "splat_parameter": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "*"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "identifier"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        }
      ]
    },
    "hash_splat_parameter": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "**"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "identifier"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        }
      ]
    },
    "block_parameter": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "&"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        }
      ]
    },
    "keyword_parameter": {
      "type": "PREC_RIGHT",
      "value": 51,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "name",
            "content": {
              "type": "SYMBOL",
              "name": "identifier"
            }
          },
          {
            "type": "IMMEDIATE_TOKEN",
            "content": {
              "type": "STRING",
              "value": ":"
            }
          },
          {
            "type": "FIELD",
            "name": "value",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_arg"
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          }
        ]
      }
    },
    "optional_parameter": {
      "type": "PREC",
      "value": 51,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "name",
            "content": {
              "type": "SYMBOL",
              "name": "identifier"
            }
          },
          {
            "type": "STRING",
            "value": "="
          },
          {
            "type": "FIELD",
            "name": "value",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          }
        ]
      }
    },
    "class": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "class"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "constant"
              },
              {
                "type": "SYMBOL",
                "name": "scope_resolution"
              }
            ]
          }
        },
        {
          "type": "FIELD",
          "name": "superclass",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "superclass"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "SYMBOL",
          "name": "_terminator"
        },
        {
          "type": "SYMBOL",
          "name": "_body_statement"
        }
      ]
    },
    "superclass": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "<"
        },
        {
          "type": "SYMBOL",
          "name": "_expression"
        }
      ]
    },
    "singleton_class": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "class"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_singleton_class_left_angle_left_langle"
          },
          "named": false,
          "value": "<<"
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "_arg"
          }
        },
        {
          "type": "SYMBOL",
          "name": "_terminator"
        },
        {
          "type": "SYMBOL",
          "name": "_body_statement"
        }
      ]
    },
    "module": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "module"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "constant"
              },
              {
                "type": "SYMBOL",
                "name": "scope_resolution"
              }
            ]
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_terminator"
                },
                {
                  "type": "SYMBOL",
                  "name": "_body_statement"
                }
              ]
            },
            {
              "type": "STRING",
              "value": "end"
            }
          ]
        }
      ]
    },
    "return_command": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "return"
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_argument_list"
            },
            "named": true,
            "value": "argument_list"
          }
        ]
      }
    },
    "yield_command": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "yield"
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_argument_list"
            },
            "named": true,
            "value": "argument_list"
          }
        ]
      }
    },
    "break_command": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "break"
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_argument_list"
            },
            "named": true,
            "value": "argument_list"
          }
        ]
      }
    },
    "next_command": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "next"
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_argument_list"
            },
            "named": true,
            "value": "argument_list"
          }
        ]
      }
    },
    "return": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "return"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "yield": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "yield"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "break": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "break"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "next": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "next"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "redo": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "redo"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "retry": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "retry"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "argument_list"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "if_modifier": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_statement"
            }
          },
          {
            "type": "STRING",
            "value": "if"
          },
          {
            "type": "FIELD",
            "name": "condition",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "unless_modifier": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_statement"
            }
          },
          {
            "type": "STRING",
            "value": "unless"
          },
          {
            "type": "FIELD",
            "name": "condition",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "while_modifier": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_statement"
            }
          },
          {
            "type": "STRING",
            "value": "while"
          },
          {
            "type": "FIELD",
            "name": "condition",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "until_modifier": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_statement"
            }
          },
          {
            "type": "STRING",
            "value": "until"
          },
          {
            "type": "FIELD",
            "name": "condition",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "rescue_modifier": {
      "type": "PREC",
      "value": 16,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "body",
            "content": {
              "type": "SYMBOL",
              "name": "_statement"
            }
          },
          {
            "type": "STRING",
            "value": "rescue"
          },
          {
            "type": "FIELD",
            "name": "handler",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "while": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "while"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "do"
          }
        }
      ]
    },
    "until": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "until"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "do"
          }
        }
      ]
    },
    "for": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "for"
        },
        {
          "type": "FIELD",
          "name": "pattern",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_lhs"
              },
              {
                "type": "SYMBOL",
                "name": "left_assignment_list"
              }
            ]
          }
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "SYMBOL",
            "name": "in"
          }
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "SYMBOL",
            "name": "do"
          }
        }
      ]
    },
    "in": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "in"
        },
        {
          "type": "SYMBOL",
          "name": "_arg"
        }
      ]
    },
    "do": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "do"
            },
            {
              "type": "SYMBOL",
              "name": "_terminator"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "end"
        }
      ]
    },
    "case": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "case"
        },
        {
          "type": "FIELD",
          "name": "value",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_statement"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SYMBOL",
            "name": "when"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "else"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "end"
        }
      ]
    },
    "when": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "when"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "FIELD",
              "name": "pattern",
              "content": {
                "type": "SYMBOL",
                "name": "pattern"
              }
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "FIELD",
                    "name": "pattern",
                    "content": {
                      "type": "SYMBOL",
                      "name": "pattern"
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "FIELD",
              "name": "body",
              "content": {
                "type": "SYMBOL",
                "name": "then"
              }
            }
          ]
        }
      ]
    },
    "pattern": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_arg"
        },
        {
          "type": "SYMBOL",
          "name": "splat_argument"
        }
      ]
    },
    "if": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "if"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "FIELD",
              "name": "consequence",
              "content": {
                "type": "SYMBOL",
                "name": "then"
              }
            }
          ]
        },
        {
          "type": "FIELD",
          "name": "alternative",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "else"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "elsif"
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": "end"
        }
      ]
    },
    "unless": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "unless"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "FIELD",
              "name": "consequence",
              "content": {
                "type": "SYMBOL",
                "name": "then"
              }
            }
          ]
        },
        {
          "type": "FIELD",
          "name": "alternative",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "else"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "elsif"
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": "end"
        }
      ]
    },
    "elsif": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "elsif"
        },
        {
          "type": "FIELD",
          "name": "condition",
          "content": {
            "type": "SYMBOL",
            "name": "_statement"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "FIELD",
              "name": "consequence",
              "content": {
                "type": "SYMBOL",
                "name": "then"
              }
            }
          ]
        },
        {
          "type": "FIELD",
          "name": "alternative",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "else"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "elsif"
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        }
      ]
    },
    "else": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "else"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "then": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "SYMBOL",
              "name": "_statements"
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_terminator"
                },
                {
                  "type": "BLANK"
                }
              ]
            },
            {
              "type": "STRING",
              "value": "then"
            },
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_statements"
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          ]
        }
      ]
    },
    "begin": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "begin"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_body_statement"
        }
      ]
    },
    "ensure": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "ensure"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        }
      ]
    },
    "rescue": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "rescue"
        },
        {
          "type": "FIELD",
          "name": "exceptions",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "exceptions"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "FIELD",
          "name": "variable",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "exception_variable"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "FIELD",
              "name": "body",
              "content": {
                "type": "SYMBOL",
                "name": "then"
              }
            }
          ]
        }
      ]
    },
    "exceptions": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_arg"
            },
            {
              "type": "SYMBOL",
              "name": "splat_argument"
            }
          ]
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_arg"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "splat_argument"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "exception_variable": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "=>"
        },
        {
          "type": "SYMBOL",
          "name": "_lhs"
        }
      ]
    },
    "_body_statement": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "rescue"
              },
              {
                "type": "SYMBOL",
                "name": "else"
              },
              {
                "type": "SYMBOL",
                "name": "ensure"
              }
            ]
          }
        },
        {
          "type": "STRING",
          "value": "end"
        }
      ]
    },
    "_expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_binary"
          },
          "named": true,
          "value": "binary"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_unary"
          },
          "named": true,
          "value": "unary"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_assignment"
          },
          "named": true,
          "value": "assignment"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_operator_assignment"
          },
          "named": true,
          "value": "operator_assignment"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_call"
          },
          "named": true,
          "value": "call"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "command_call_with_block"
          },
          "named": true,
          "value": "call"
        },
        {
          "type": "PREC_LEFT",
          "value": 0,
          "content": {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "_chained_command_call"
            },
            "named": true,
            "value": "call"
          }
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "return_command"
          },
          "named": true,
          "value": "return"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "yield_command"
          },
          "named": true,
          "value": "yield"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "break_command"
          },
          "named": true,
          "value": "break"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "next_command"
          },
          "named": true,
          "value": "next"
        },
        {
          "type": "SYMBOL",
          "name": "_arg"
        }
      ]
    },
    "_arg": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_primary"
        },
        {
          "type": "SYMBOL",
          "name": "assignment"
        },
        {
          "type": "SYMBOL",
          "name": "operator_assignment"
        },
        {
          "type": "SYMBOL",
          "name": "conditional"
        },
        {
          "type": "SYMBOL",
          "name": "range"
        },
        {
          "type": "SYMBOL",
          "name": "binary"
        },
        {
          "type": "SYMBOL",
          "name": "unary"
        }
      ]
    },
    "_primary": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "parenthesized_statements"
        },
        {
          "type": "SYMBOL",
          "name": "_lhs"
        },
        {
          "type": "SYMBOL",
          "name": "array"
        },
        {
          "type": "SYMBOL",
          "name": "string_array"
        },
        {
          "type": "SYMBOL",
          "name": "symbol_array"
        },
        {
          "type": "SYMBOL",
          "name": "hash"
        },
        {
          "type": "SYMBOL",
          "name": "subshell"
        },
        {
          "type": "SYMBOL",
          "name": "simple_symbol"
        },
        {
          "type": "SYMBOL",
          "name": "delimited_symbol"
        },
        {
          "type": "SYMBOL",
          "name": "integer"
        },
        {
          "type": "SYMBOL",
          "name": "float"
        },
        {
          "type": "SYMBOL",
          "name": "complex"
        },
        {
          "type": "SYMBOL",
          "name": "rational"
        },
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "SYMBOL",
          "name": "character"
        },
        {
          "type": "SYMBOL",
          "name": "chained_string"
        },
        {
          "type": "SYMBOL",
          "name": "regex"
        },
        {
          "type": "SYMBOL",
          "name": "lambda"
        },
        {
          "type": "SYMBOL",
          "name": "method"
        },
        {
          "type": "SYMBOL",
          "name": "singleton_method"
        },
        {
          "type": "SYMBOL",
          "name": "class"
        },
        {
          "type": "SYMBOL",
          "name": "singleton_class"
        },
        {
          "type": "SYMBOL",
          "name": "module"
        },
        {
          "type": "SYMBOL",
          "name": "begin"
        },
        {
          "type": "SYMBOL",
          "name": "while"
        },
        {
          "type": "SYMBOL",
          "name": "until"
        },
        {
          "type": "SYMBOL",
          "name": "if"
        },
        {
          "type": "SYMBOL",
          "name": "unless"
        },
        {
          "type": "SYMBOL",
          "name": "for"
        },
        {
          "type": "SYMBOL",
          "name": "case"
        },
        {
          "type": "SYMBOL",
          "name": "return"
        },
        {
          "type": "SYMBOL",
          "name": "yield"
        },
        {
          "type": "SYMBOL",
          "name": "break"
        },
        {
          "type": "SYMBOL",
          "name": "next"
        },
        {
          "type": "SYMBOL",
          "name": "redo"
        },
        {
          "type": "SYMBOL",
          "name": "retry"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "parenthesized_unary"
          },
          "named": true,
          "value": "unary"
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "unary_literal"
          },
          "named": true,
          "value": "unary"
        },
        {
          "type": "SYMBOL",
          "name": "heredoc_beginning"
        }
      ]
    },
    "parenthesized_statements": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": ")"
        }
      ]
    },
    "element_reference": {
      "type": "PREC_LEFT",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "object",
            "content": {
              "type": "SYMBOL",
              "name": "_primary"
            }
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "_element_reference_bracket"
            },
            "named": false,
            "value": "["
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_argument_list_with_trailing_comma"
              },
              {
                "type": "BLANK"
              }
            ]
          },
          {
            "type": "STRING",
            "value": "]"
          }
        ]
      }
    },
    "scope_resolution": {
      "type": "PREC_LEFT",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "::"
              },
              {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "scope",
                    "content": {
                      "type": "SYMBOL",
                      "name": "_primary"
                    }
                  },
                  {
                    "type": "IMMEDIATE_TOKEN",
                    "content": {
                      "type": "STRING",
                      "value": "::"
                    }
                  }
                ]
              }
            ]
          },
          {
            "type": "FIELD",
            "name": "name",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "identifier"
                },
                {
                  "type": "SYMBOL",
                  "name": "constant"
                }
              ]
            }
          }
        ]
      }
    },
    "_call": {
      "type": "PREC_LEFT",
      "value": 56,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "receiver",
            "content": {
              "type": "SYMBOL",
              "name": "_primary"
            }
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": "."
              },
              {
                "type": "STRING",
                "value": "&."
              }
            ]
          },
          {
            "type": "FIELD",
            "name": "method",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "identifier"
                },
                {
                  "type": "SYMBOL",
                  "name": "operator"
                },
                {
                  "type": "SYMBOL",
                  "name": "constant"
                },
                {
                  "type": "SYMBOL",
                  "name": "argument_list"
                }
              ]
            }
          }
        ]
      }
    },
    "command_call": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_call"
            },
            {
              "type": "SYMBOL",
              "name": "_chained_command_call"
            },
            {
              "type": "FIELD",
              "name": "method",
              "content": {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_variable"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "scope_resolution"
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "FIELD",
          "name": "arguments",
          "content": {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_argument_list"
            },
            "named": true,
            "value": "argument_list"
          }
        }
      ]
    },
    "command_call_with_block": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_call"
                },
                {
                  "type": "FIELD",
                  "name": "method",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_variable"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "scope_resolution"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "PREC",
              "value": 1,
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "arguments",
                    "content": {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "command_argument_list"
                      },
                      "named": true,
                      "value": "argument_list"
                    }
                  },
                  {
                    "type": "FIELD",
                    "name": "block",
                    "content": {
                      "type": "SYMBOL",
                      "name": "block"
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_call"
                },
                {
                  "type": "FIELD",
                  "name": "method",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_variable"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "scope_resolution"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "PREC",
              "value": -1,
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "arguments",
                    "content": {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "command_argument_list"
                      },
                      "named": true,
                      "value": "argument_list"
                    }
                  },
                  {
                    "type": "FIELD",
                    "name": "block",
                    "content": {
                      "type": "SYMBOL",
                      "name": "do_block"
                    }
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    "_chained_command_call": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "receiver",
          "content": {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "command_call_with_block"
            },
            "named": true,
            "value": "call"
          }
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "STRING",
              "value": "."
            },
            {
              "type": "STRING",
              "value": "&."
            }
          ]
        },
        {
          "type": "FIELD",
          "name": "method",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "identifier"
              },
              {
                "type": "SYMBOL",
                "name": "operator"
              },
              {
                "type": "SYMBOL",
                "name": "constant"
              },
              {
                "type": "SYMBOL",
                "name": "argument_list"
              }
            ]
          }
        }
      ]
    },
    "call": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_call"
                },
                {
                  "type": "FIELD",
                  "name": "method",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_variable"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "scope_resolution"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "FIELD",
              "name": "arguments",
              "content": {
                "type": "SYMBOL",
                "name": "argument_list"
              }
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_call"
                },
                {
                  "type": "FIELD",
                  "name": "method",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_variable"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "scope_resolution"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "PREC",
              "value": 1,
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "arguments",
                    "content": {
                      "type": "SYMBOL",
                      "name": "argument_list"
                    }
                  },
                  {
                    "type": "FIELD",
                    "name": "block",
                    "content": {
                      "type": "SYMBOL",
                      "name": "block"
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "_call"
                },
                {
                  "type": "FIELD",
                  "name": "method",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "SYMBOL",
                        "name": "_variable"
                      },
                      {
                        "type": "SYMBOL",
                        "name": "scope_resolution"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "PREC",
              "value": -1,
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "FIELD",
                    "name": "arguments",
                    "content": {
                      "type": "SYMBOL",
                      "name": "argument_list"
                    }
                  },
                  {
                    "type": "FIELD",
                    "name": "block",
                    "content": {
                      "type": "SYMBOL",
                      "name": "do_block"
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "type": "PREC",
          "value": 1,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_call"
                  },
                  {
                    "type": "FIELD",
                    "name": "method",
                    "content": {
                      "type": "CHOICE",
                      "members": [
                        {
                          "type": "SYMBOL",
                          "name": "_variable"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "scope_resolution"
                        }
                      ]
                    }
                  }
                ]
              },
              {
                "type": "FIELD",
                "name": "block",
                "content": {
                  "type": "SYMBOL",
                  "name": "block"
                }
              }
            ]
          }
        },
        {
          "type": "PREC",
          "value": -1,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_call"
                  },
                  {
                    "type": "FIELD",
                    "name": "method",
                    "content": {
                      "type": "CHOICE",
                      "members": [
                        {
                          "type": "SYMBOL",
                          "name": "_variable"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "scope_resolution"
                        }
                      ]
                    }
                  }
                ]
              },
              {
                "type": "FIELD",
                "name": "block",
                "content": {
                  "type": "SYMBOL",
                  "name": "do_block"
                }
              }
            ]
          }
        }
      ]
    },
    "command_argument_list": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_argument"
          },
          {
            "type": "REPEAT",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "SYMBOL",
                  "name": "_argument"
                }
              ]
            }
          }
        ]
      }
    },
    "argument_list": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "IMMEDIATE_TOKEN",
            "content": {
              "type": "STRING",
              "value": "("
            }
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_argument_list_with_trailing_comma"
              },
              {
                "type": "BLANK"
              }
            ]
          },
          {
            "type": "STRING",
            "value": ")"
          }
        ]
      }
    },
    "_argument_list_with_trailing_comma": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_argument"
              },
              {
                "type": "REPEAT",
                "content": {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "SYMBOL",
                      "name": "_argument"
                    }
                  ]
                }
              }
            ]
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "_argument": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_expression"
          },
          {
            "type": "SYMBOL",
            "name": "splat_argument"
          },
          {
            "type": "SYMBOL",
            "name": "hash_splat_argument"
          },
          {
            "type": "SYMBOL",
            "name": "forward_argument"
          },
          {
            "type": "SYMBOL",
            "name": "block_argument"
          },
          {
            "type": "SYMBOL",
            "name": "pair"
          }
        ]
      }
    },
    "forward_argument": {
      "type": "STRING",
      "value": "..."
    },
    "splat_argument": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_splat_star"
          },
          "named": false,
          "value": "*"
        },
        {
          "type": "SYMBOL",
          "name": "_arg"
        }
      ]
    },
    "hash_splat_argument": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_hash_splat_star_star"
          },
          "named": false,
          "value": "**"
        },
        {
          "type": "SYMBOL",
          "name": "_arg"
        }
      ]
    },
    "block_argument": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_block_ampersand"
          },
          "named": false,
          "value": "&"
        },
        {
          "type": "SYMBOL",
          "name": "_arg"
        }
      ]
    },
    "do_block": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "do"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_terminator"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "FIELD",
                  "name": "parameters",
                  "content": {
                    "type": "SYMBOL",
                    "name": "block_parameters"
                  }
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_terminator"
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "SYMBOL",
          "name": "_body_statement"
        }
      ]
    },
    "block": {
      "type": "PREC",
      "value": 1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "{"
          },
          {
            "type": "FIELD",
            "name": "parameters",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "block_parameters"
                },
                {
                  "type": "BLANK"
                }
              ]
            }
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_statements"
              },
              {
                "type": "BLANK"
              }
            ]
          },
          {
            "type": "STRING",
            "value": "}"
          }
        ]
      }
    },
    "assignment": {
      "type": "PREC_RIGHT",
      "value": 15,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_lhs"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "left_assignment_list"
                    }
                  ]
                }
              },
              {
                "type": "STRING",
                "value": "="
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_arg"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "splat_argument"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "right_assignment_list"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
    },
    "command_assignment": {
      "type": "PREC_RIGHT",
      "value": 15,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_lhs"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "left_assignment_list"
                    }
                  ]
                }
              },
              {
                "type": "STRING",
                "value": "="
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_expression"
                }
              }
            ]
          }
        ]
      }
    },
    "operator_assignment": {
      "type": "PREC_RIGHT",
      "value": 15,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "left",
            "content": {
              "type": "SYMBOL",
              "name": "_lhs"
            }
          },
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "+="
                },
                {
                  "type": "STRING",
                  "value": "-="
                },
                {
                  "type": "STRING",
                  "value": "*="
                },
                {
                  "type": "STRING",
                  "value": "**="
                },
                {
                  "type": "STRING",
                  "value": "/="
                },
                {
                  "type": "STRING",
                  "value": "||="
                },
                {
                  "type": "STRING",
                  "value": "|="
                },
                {
                  "type": "STRING",
                  "value": "&&="
                },
                {
                  "type": "STRING",
                  "value": "&="
                },
                {
                  "type": "STRING",
                  "value": "%="
                },
                {
                  "type": "STRING",
                  "value": ">>="
                },
                {
                  "type": "STRING",
                  "value": "<<="
                },
                {
                  "type": "STRING",
                  "value": "^="
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "right",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          }
        ]
      }
    },
    "command_operator_assignment": {
      "type": "PREC_RIGHT",
      "value": 15,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "left",
            "content": {
              "type": "SYMBOL",
              "name": "_lhs"
            }
          },
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "+="
                },
                {
                  "type": "STRING",
                  "value": "-="
                },
                {
                  "type": "STRING",
                  "value": "*="
                },
                {
                  "type": "STRING",
                  "value": "**="
                },
                {
                  "type": "STRING",
                  "value": "/="
                },
                {
                  "type": "STRING",
                  "value": "||="
                },
                {
                  "type": "STRING",
                  "value": "|="
                },
                {
                  "type": "STRING",
                  "value": "&&="
                },
                {
                  "type": "STRING",
                  "value": "&="
                },
                {
                  "type": "STRING",
                  "value": "%="
                },
                {
                  "type": "STRING",
                  "value": ">>="
                },
                {
                  "type": "STRING",
                  "value": "<<="
                },
                {
                  "type": "STRING",
                  "value": "^="
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "right",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "conditional": {
      "type": "PREC_RIGHT",
      "value": 20,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "condition",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          },
          {
            "type": "STRING",
            "value": "?"
          },
          {
            "type": "FIELD",
            "name": "consequence",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          },
          {
            "type": "STRING",
            "value": ":"
          },
          {
            "type": "FIELD",
            "name": "alternative",
            "content": {
              "type": "SYMBOL",
              "name": "_arg"
            }
          }
        ]
      }
    },
    "range": {
      "type": "PREC_RIGHT",
      "value": 25,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "begin",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ".."
                    },
                    {
                      "type": "STRING",
                      "value": "..."
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "end",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ".."
                    },
                    {
                      "type": "STRING",
                      "value": "..."
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "end",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          },
          {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "begin",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ".."
                    },
                    {
                      "type": "STRING",
                      "value": "..."
                    }
                  ]
                }
              }
            ]
          }
        ]
      }
    },
    "binary": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC_LEFT",
          "value": -2,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "and"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": -2,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "or"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 30,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "||"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 30,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "&&"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 60,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "<<"
                    },
                    {
                      "type": "STRING",
                      "value": ">>"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 45,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "<"
                    },
                    {
                      "type": "STRING",
                      "value": "<="
                    },
                    {
                      "type": "STRING",
                      "value": ">"
                    },
                    {
                      "type": "STRING",
                      "value": ">="
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 55,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "&"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 50,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "^"
                    },
                    {
                      "type": "STRING",
                      "value": "|"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 65,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "+"
                    },
                    {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "_binary_minus"
                      },
                      "named": false,
                      "value": "-"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_LEFT",
          "value": 70,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "/"
                    },
                    {
                      "type": "STRING",
                      "value": "%"
                    },
                    {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "_binary_star"
                      },
                      "named": false,
                      "value": "*"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 40,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "=="
                    },
                    {
                      "type": "STRING",
                      "value": "!="
                    },
                    {
                      "type": "STRING",
                      "value": "==="
                    },
                    {
                      "type": "STRING",
                      "value": "<=>"
                    },
                    {
                      "type": "STRING",
                      "value": "=~"
                    },
                    {
                      "type": "STRING",
                      "value": "!~"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 80,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "left",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              },
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "ALIAS",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_binary_star_star"
                  },
                  "named": false,
                  "value": "**"
                }
              },
              {
                "type": "FIELD",
                "name": "right",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        }
      ]
    },
    "command_binary": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "left",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          },
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "or"
                },
                {
                  "type": "STRING",
                  "value": "and"
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "right",
            "content": {
              "type": "SYMBOL",
              "name": "_expression"
            }
          }
        ]
      }
    },
    "unary": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "defined?"
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 5,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "not"
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 75,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "_unary_minus"
                      },
                      "named": false,
                      "value": "-"
                    },
                    {
                      "type": "STRING",
                      "value": "+"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 85,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "!"
                    },
                    {
                      "type": "STRING",
                      "value": "~"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_arg"
                }
              }
            ]
          }
        }
      ]
    },
    "command_unary": {
      "type": "CHOICE",
      "members": [
        {
          "type": "PREC",
          "value": 10,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "defined?"
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 5,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "STRING",
                  "value": "not"
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 75,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "ALIAS",
                      "content": {
                        "type": "SYMBOL",
                        "name": "_unary_minus"
                      },
                      "named": false,
                      "value": "-"
                    },
                    {
                      "type": "STRING",
                      "value": "+"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_expression"
                }
              }
            ]
          }
        },
        {
          "type": "PREC_RIGHT",
          "value": 85,
          "content": {
            "type": "SEQ",
            "members": [
              {
                "type": "FIELD",
                "name": "operator",
                "content": {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": "!"
                    },
                    {
                      "type": "STRING",
                      "value": "~"
                    }
                  ]
                }
              },
              {
                "type": "FIELD",
                "name": "operand",
                "content": {
                  "type": "SYMBOL",
                  "name": "_expression"
                }
              }
            ]
          }
        }
      ]
    },
    "parenthesized_unary": {
      "type": "PREC",
      "value": 56,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "STRING",
                  "value": "defined?"
                },
                {
                  "type": "STRING",
                  "value": "not"
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "operand",
            "content": {
              "type": "SYMBOL",
              "name": "parenthesized_statements"
            }
          }
        ]
      }
    },
    "unary_literal": {
      "type": "PREC_RIGHT",
      "value": 75,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "operator",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "ALIAS",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_unary_minus"
                  },
                  "named": false,
                  "value": "-"
                },
                {
                  "type": "STRING",
                  "value": "+"
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "operand",
            "content": {
              "type": "CHOICE",
              "members": [
                {
                  "type": "SYMBOL",
                  "name": "integer"
                },
                {
                  "type": "SYMBOL",
                  "name": "float"
                }
              ]
            }
          }
        ]
      }
    },
    "right_assignment_list": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_arg"
              },
              {
                "type": "SYMBOL",
                "name": "splat_argument"
              }
            ]
          },
          {
            "type": "REPEAT",
            "content": {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": ","
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "SYMBOL",
                      "name": "_arg"
                    },
                    {
                      "type": "SYMBOL",
                      "name": "splat_argument"
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    },
    "left_assignment_list": {
      "type": "SYMBOL",
      "name": "_mlhs"
    },
    "_mlhs": {
      "type": "PREC_LEFT",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "SEQ",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "_lhs"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "rest_assignment"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "destructured_left_assignment"
                  }
                ]
              },
              {
                "type": "REPEAT",
                "content": {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "CHOICE",
                      "members": [
                        {
                          "type": "SYMBOL",
                          "name": "_lhs"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "rest_assignment"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "destructured_left_assignment"
                        }
                      ]
                    }
                  ]
                }
              }
            ]
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "STRING",
                "value": ","
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "destructured_left_assignment": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "("
          },
          {
            "type": "SYMBOL",
            "name": "_mlhs"
          },
          {
            "type": "STRING",
            "value": ")"
          }
        ]
      }
    },
    "rest_assignment": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "*"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "_lhs"
              },
              {
                "type": "BLANK"
              }
            ]
          }
        ]
      }
    },
    "_lhs": {
      "type": "PREC_LEFT",
      "value": 0,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SYMBOL",
            "name": "_variable"
          },
          {
            "type": "SYMBOL",
            "name": "true"
          },
          {
            "type": "SYMBOL",
            "name": "false"
          },
          {
            "type": "SYMBOL",
            "name": "nil"
          },
          {
            "type": "SYMBOL",
            "name": "scope_resolution"
          },
          {
            "type": "SYMBOL",
            "name": "element_reference"
          },
          {
            "type": "ALIAS",
            "content": {
              "type": "SYMBOL",
              "name": "_call"
            },
            "named": true,
            "value": "call"
          },
          {
            "type": "SYMBOL",
            "name": "call"
          }
        ]
      }
    },
    "_variable": {
      "type": "PREC_RIGHT",
      "value": 0,
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SYMBOL",
            "name": "self"
          },
          {
            "type": "SYMBOL",
            "name": "super"
          },
          {
            "type": "SYMBOL",
            "name": "instance_variable"
          },
          {
            "type": "SYMBOL",
            "name": "class_variable"
          },
          {
            "type": "SYMBOL",
            "name": "global_variable"
          },
          {
            "type": "SYMBOL",
            "name": "identifier"
          },
          {
            "type": "SYMBOL",
            "name": "constant"
          }
        ]
      }
    },
    "operator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "STRING",
          "value": ".."
        },
        {
          "type": "STRING",
          "value": "|"
        },
        {
          "type": "STRING",
          "value": "^"
        },
        {
          "type": "STRING",
          "value": "&"
        },
        {
          "type": "STRING",
          "value": "<=>"
        },
        {
          "type": "STRING",
          "value": "=="
        },
        {
          "type": "STRING",
          "value": "==="
        },
        {
          "type": "STRING",
          "value": "=~"
        },
        {
          "type": "STRING",
          "value": ">"
        },
        {
          "type": "STRING",
          "value": ">="
        },
        {
          "type": "STRING",
          "value": "<"
        },
        {
          "type": "STRING",
          "value": "<="
        },
        {
          "type": "STRING",
          "value": "+"
        },
        {
          "type": "STRING",
          "value": "-"
        },
        {
          "type": "STRING",
          "value": "*"
        },
        {
          "type": "STRING",
          "value": "/"
        },
        {
          "type": "STRING",
          "value": "%"
        },
        {
          "type": "STRING",
          "value": "!"
        },
        {
          "type": "STRING",
          "value": "!~"
        },
        {
          "type": "STRING",
          "value": "**"
        },
        {
          "type": "STRING",
          "value": "<<"
        },
        {
          "type": "STRING",
          "value": ">>"
        },
        {
          "type": "STRING",
          "value": "~"
        },
        {
          "type": "STRING",
          "value": "+@"
        },
        {
          "type": "STRING",
          "value": "-@"
        },
        {
          "type": "STRING",
          "value": "[]"
        },
        {
          "type": "STRING",
          "value": "[]="
        },
        {
          "type": "STRING",
          "value": "`"
        }
      ]
    },
    "_method_name": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "identifier"
        },
        {
          "type": "SYMBOL",
          "name": "constant"
        },
        {
          "type": "SYMBOL",
          "name": "setter"
        },
        {
          "type": "SYMBOL",
          "name": "simple_symbol"
        },
        {
          "type": "SYMBOL",
          "name": "delimited_symbol"
        },
        {
          "type": "SYMBOL",
          "name": "operator"
        },
        {
          "type": "SYMBOL",
          "name": "instance_variable"
        },
        {
          "type": "SYMBOL",
          "name": "class_variable"
        },
        {
          "type": "SYMBOL",
          "name": "global_variable"
        }
      ]
    },
    "setter": {
      "type": "SEQ",
      "members": [
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "identifier"
          }
        },
        {
          "type": "IMMEDIATE_TOKEN",
          "content": {
            "type": "STRING",
            "value": "="
          }
        }
      ]
    },
    "undef": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "undef"
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_method_name"
            },
            {
              "type": "REPEAT",
              "content": {
                "type": "SEQ",
                "members": [
                  {
                    "type": "STRING",
                    "value": ","
                  },
                  {
                    "type": "SYMBOL",
                    "name": "_method_name"
                  }
                ]
              }
            }
          ]
        }
      ]
    },
    "alias": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "alias"
        },
        {
          "type": "FIELD",
          "name": "name",
          "content": {
            "type": "SYMBOL",
            "name": "_method_name"
          }
        },
        {
          "type": "FIELD",
          "name": "alias",
          "content": {
            "type": "SYMBOL",
            "name": "_method_name"
          }
        }
      ]
    },
    "comment": {
      "type": "TOKEN",
      "content": {
        "type": "PREC",
        "value": -2,
        "content": {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "STRING",
                  "value": "#"
                },
                {
                  "type": "PATTERN",
                  "value": ".*"
                }
              ]
            },
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "PATTERN",
                  "value": "=begin.*\\r?\\n"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "CHOICE",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "[^=]"
                      },
                      {
                        "type": "PATTERN",
                        "value": "=[^e]"
                      },
                      {
                        "type": "PATTERN",
                        "value": "=e[^n]"
                      },
                      {
                        "type": "PATTERN",
                        "value": "=en[^d]"
                      }
                    ]
                  }
                },
                {
                  "type": "PATTERN",
                  "value": "=end"
                }
              ]
            }
          ]
        }
      }
    },
    "integer": {
      "type": "PATTERN",
      "value": "0[bB][01](_?[01])*|0[oO]?[0-7](_?[0-7])*|(0[dD])?\\d(_?\\d)*|0[xX][0-9a-fA-F](_?[0-9a-fA-F])*"
    },
    "float": {
      "type": "PATTERN",
      "value": "\\d(_?\\d)*(\\.\\d)?(_?\\d)*([eE][\\+-]?\\d(_?\\d)*)?"
    },
    "complex": {
      "type": "PATTERN",
      "value": "(\\d+)?(\\+|-)?(\\d+)i"
    },
    "rational": {
      "type": "SEQ",
      "members": [
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "integer"
            },
            {
              "type": "SYMBOL",
              "name": "float"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "r"
        }
      ]
    },
    "super": {
      "type": "STRING",
      "value": "super"
    },
    "self": {
      "type": "STRING",
      "value": "self"
    },
    "true": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "STRING",
            "value": "true"
          },
          {
            "type": "STRING",
            "value": "TRUE"
          }
        ]
      }
    },
    "false": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "STRING",
            "value": "false"
          },
          {
            "type": "STRING",
            "value": "FALSE"
          }
        ]
      }
    },
    "nil": {
      "type": "TOKEN",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "STRING",
            "value": "nil"
          },
          {
            "type": "STRING",
            "value": "NIL"
          }
        ]
      }
    },
    "constant": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "PATTERN",
            "value": "[A-Z]"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]*"
          },
          {
            "type": "PATTERN",
            "value": "(\\?|\\!)?"
          }
        ]
      }
    },
    "identifier": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\sA-Z0-9:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]*"
          },
          {
            "type": "PATTERN",
            "value": "(\\?|\\!)?"
          }
        ]
      }
    },
    "instance_variable": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "@"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s0-9:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]*"
          }
        ]
      }
    },
    "class_variable": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "@@"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s0-9:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]"
          },
          {
            "type": "PATTERN",
            "value": "[^\\x00-\\x1F\\s:;`\"''@$#.,|^&<=>+\\-*/\\\\%?!~()\\[\\]{}]*"
          }
        ]
      }
    },
    "global_variable": {
      "type": "PATTERN",
      "value": "\\$-?(([!@&`''+~=/\\\\,;.<>*$?:\"])|([0-9]*)|([a-zA-Z_][a-zA-Z0-9_]*))"
    },
    "chained_string": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "string"
        },
        {
          "type": "REPEAT1",
          "content": {
            "type": "SYMBOL",
            "name": "string"
          }
        }
      ]
    },
    "character": {
      "type": "PATTERN",
      "value": "\\?(\\\\\\S({[0-9A-Fa-f]*}|[0-9A-Fa-f]*|-\\S([MC]-\\S)?)?|\\S)"
    },
    "interpolation": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "#{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_statements"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "string": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_start"
          },
          "named": false,
          "value": "\""
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_literal_contents"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "\""
        }
      ]
    },
    "subshell": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_subshell_start"
          },
          "named": false,
          "value": "`"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_literal_contents"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "`"
        }
      ]
    },
    "string_array": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_array_start"
          },
          "named": false,
          "value": "%w("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "PATTERN",
              "value": "\\s+"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "ALIAS",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_literal_contents"
                  },
                  "named": true,
                  "value": "bare_string"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "\\s+"
                      },
                      {
                        "type": "ALIAS",
                        "content": {
                          "type": "SYMBOL",
                          "name": "_literal_contents"
                        },
                        "named": true,
                        "value": "bare_string"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "PATTERN",
              "value": "\\s+"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": ")"
        }
      ]
    },
    "symbol_array": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_symbol_array_start"
          },
          "named": false,
          "value": "%i("
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "PATTERN",
              "value": "\\s+"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "ALIAS",
                  "content": {
                    "type": "SYMBOL",
                    "name": "_literal_contents"
                  },
                  "named": true,
                  "value": "bare_symbol"
                },
                {
                  "type": "REPEAT",
                  "content": {
                    "type": "SEQ",
                    "members": [
                      {
                        "type": "PATTERN",
                        "value": "\\s+"
                      },
                      {
                        "type": "ALIAS",
                        "content": {
                          "type": "SYMBOL",
                          "name": "_literal_contents"
                        },
                        "named": true,
                        "value": "bare_symbol"
                      }
                    ]
                  }
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "PATTERN",
              "value": "\\s+"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": ")"
        }
      ]
    },
    "delimited_symbol": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_symbol_start"
          },
          "named": false,
          "value": ":\""
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_literal_contents"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "\""
        }
      ]
    },
    "regex": {
      "type": "SEQ",
      "members": [
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_regex_start"
          },
          "named": false,
          "value": "/"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_literal_contents"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "ALIAS",
          "content": {
            "type": "SYMBOL",
            "name": "_string_end"
          },
          "named": false,
          "value": "/"
        }
      ]
    },
    "heredoc_body": {
      "type": "SEQ",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_heredoc_body_start"
        },
        {
          "type": "REPEAT",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "heredoc_content"
              },
              {
                "type": "SYMBOL",
                "name": "interpolation"
              },
              {
                "type": "SYMBOL",
                "name": "escape_sequence"
              }
            ]
          }
        },
        {
          "type": "SYMBOL",
          "name": "heredoc_end"
        }
      ]
    },
    "_literal_contents": {
      "type": "REPEAT1",
      "content": {
        "type": "CHOICE",
        "members": [
          {
            "type": "SYMBOL",
            "name": "string_content"
          },
          {
            "type": "SYMBOL",
            "name": "interpolation"
          },
          {
            "type": "SYMBOL",
            "name": "escape_sequence"
          }
        ]
      }
    },
    "escape_sequence": {
      "type": "TOKEN",
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "\\"
          },
          {
            "type": "CHOICE",
            "members": [
              {
                "type": "PATTERN",
                "value": "[^ux0-7]"
              },
              {
                "type": "PATTERN",
                "value": "x[0-9a-fA-F]{1,2}"
              },
              {
                "type": "PATTERN",
                "value": "[0-7]{1,3}"
              },
              {
                "type": "PATTERN",
                "value": "u[0-9a-fA-F]{4}"
              },
              {
                "type": "PATTERN",
                "value": "u{[0-9a-fA-F ]+}"
              }
            ]
          }
        ]
      }
    },
    "array": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "["
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SYMBOL",
              "name": "_argument_list_with_trailing_comma"
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "]"
        }
      ]
    },
    "hash": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "{"
        },
        {
          "type": "CHOICE",
          "members": [
            {
              "type": "SEQ",
              "members": [
                {
                  "type": "SEQ",
                  "members": [
                    {
                      "type": "CHOICE",
                      "members": [
                        {
                          "type": "SYMBOL",
                          "name": "pair"
                        },
                        {
                          "type": "SYMBOL",
                          "name": "hash_splat_argument"
                        }
                      ]
                    },
                    {
                      "type": "REPEAT",
                      "content": {
                        "type": "SEQ",
                        "members": [
                          {
                            "type": "STRING",
                            "value": ","
                          },
                          {
                            "type": "CHOICE",
                            "members": [
                              {
                                "type": "SYMBOL",
                                "name": "pair"
                              },
                              {
                                "type": "SYMBOL",
                                "name": "hash_splat_argument"
                              }
                            ]
                          }
                        ]
                      }
                    }
                  ]
                },
                {
                  "type": "CHOICE",
                  "members": [
                    {
                      "type": "STRING",
                      "value": ","
                    },
                    {
                      "type": "BLANK"
                    }
                  ]
                }
              ]
            },
            {
              "type": "BLANK"
            }
          ]
        },
        {
          "type": "STRING",
          "value": "}"
        }
      ]
    },
    "pair": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SEQ",
          "members": [
            {
              "type": "FIELD",
              "name": "key",
              "content": {
                "type": "SYMBOL",
                "name": "_arg"
              }
            },
            {
              "type": "STRING",
              "value": "=>"
            },
            {
              "type": "FIELD",
              "name": "value",
              "content": {
                "type": "SYMBOL",
                "name": "_arg"
              }
            }
          ]
        },
        {
          "type": "SEQ",
          "members": [
            {
              "type": "FIELD",
              "name": "key",
              "content": {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "SYMBOL",
                    "name": "hash_key_symbol"
                  },
                  {
                    "type": "ALIAS",
                    "content": {
                      "type": "SYMBOL",
                      "name": "identifier"
                    },
                    "named": true,
                    "value": "hash_key_symbol"
                  },
                  {
                    "type": "ALIAS",
                    "content": {
                      "type": "SYMBOL",
                      "name": "constant"
                    },
                    "named": true,
                    "value": "hash_key_symbol"
                  },
                  {
                    "type": "SYMBOL",
                    "name": "string"
                  }
                ]
              }
            },
            {
              "type": "IMMEDIATE_TOKEN",
              "content": {
                "type": "STRING",
                "value": ":"
              }
            },
            {
              "type": "FIELD",
              "name": "value",
              "content": {
                "type": "SYMBOL",
                "name": "_arg"
              }
            }
          ]
        }
      ]
    },
    "lambda": {
      "type": "SEQ",
      "members": [
        {
          "type": "STRING",
          "value": "->"
        },
        {
          "type": "FIELD",
          "name": "parameters",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "CHOICE",
                "members": [
                  {
                    "type": "ALIAS",
                    "content": {
                      "type": "SYMBOL",
                      "name": "parameters"
                    },
                    "named": true,
                    "value": "lambda_parameters"
                  },
                  {
                    "type": "ALIAS",
                    "content": {
                      "type": "SYMBOL",
                      "name": "bare_parameters"
                    },
                    "named": true,
                    "value": "lambda_parameters"
                  }
                ]
              },
              {
                "type": "BLANK"
              }
            ]
          }
        },
        {
          "type": "FIELD",
          "name": "body",
          "content": {
            "type": "CHOICE",
            "members": [
              {
                "type": "SYMBOL",
                "name": "block"
              },
              {
                "type": "SYMBOL",
                "name": "do_block"
              }
            ]
          }
        }
      ]
    },
    "empty_statement": {
      "type": "PREC",
      "value": -1,
      "content": {
        "type": "STRING",
        "value": ";"
      }
    },
    "_terminator": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "_line_break"
        },
        {
          "type": "STRING",
          "value": ";"
        }
      ]
    }
  },
  "extras": [
    {
      "type": "SYMBOL",
      "name": "comment"
    },
    {
      "type": "SYMBOL",
      "name": "heredoc_body"
    },
    {
      "type": "PATTERN",
      "value": "\\s"
    },
    {
      "type": "PATTERN",
      "value": "\\\\\\r?\\n"
    }
  ],
  "conflicts": [],
  "precedences": [],
  "externals": [
    {
      "type": "SYMBOL",
      "name": "_line_break"
    },
    {
      "type": "SYMBOL",
      "name": "simple_symbol"
    },
    {
      "type": "SYMBOL",
      "name": "_string_start"
    },
    {
      "type": "SYMBOL",
      "name": "_symbol_start"
    },
    {
      "type": "SYMBOL",
      "name": "_subshell_start"
    },
    {
      "type": "SYMBOL",
      "name": "_regex_start"
    },
    {
      "type": "SYMBOL",
      "name": "_string_array_start"
    },
    {
      "type": "SYMBOL",
      "name": "_symbol_array_start"
    },
    {
      "type": "SYMBOL",
      "name": "_heredoc_body_start"
    },
    {
      "type": "SYMBOL",
      "name": "string_content"
    },
    {
      "type": "SYMBOL",
      "name": "heredoc_content"
    },
    {
      "type": "SYMBOL",
      "name": "_string_end"
    },
    {
      "type": "SYMBOL",
      "name": "heredoc_end"
    },
    {
      "type": "SYMBOL",
      "name": "heredoc_beginning"
    },
    {
      "type": "STRING",
      "value": "/"
    },
    {
      "type": "SYMBOL",
      "name": "_block_ampersand"
    },
    {
      "type": "SYMBOL",
      "name": "_splat_star"
    },
    {
      "type": "SYMBOL",
      "name": "_unary_minus"
    },
    {
      "type": "SYMBOL",
      "name": "_binary_minus"
    },
    {
      "type": "SYMBOL",
      "name": "_binary_star"
    },
    {
      "type": "SYMBOL",
      "name": "_singleton_class_left_angle_left_langle"
    },
    {
      "type": "SYMBOL",
      "name": "hash_key_symbol"
    },
    {
      "type": "SYMBOL",
      "name": "_hash_splat_star_star"
    },
    {
      "type": "SYMBOL",
      "name": "_binary_star_star"
    },
    {
      "type": "SYMBOL",
      "name": "_element_reference_bracket"
    }
  ],
  "inline": [],
  "supertypes": [
    "_statement",
    "_arg",
    "_method_name",
    "_variable",
    "_primary",
    "_lhs"
  ]
}

'
		highlight: '; Keywords

[
  "alias"
  "and"
  "begin"
  "break"
  "case"
  "class"
  "def"
  "do"
  "else"
  "elsif"
  "end"
  "ensure"
  "for"
  "if"
  "in"
  "module"
  "next"
  "or"
  "rescue"
  "retry"
  "return"
  "then"
  "unless"
  "until"
  "when"
  "while"
  "yield"
] @keyword

((identifier) @keyword
 (#match? @keyword "^(private|protected|public)$"))

; Function calls

((identifier) @function.method.builtin
 (#eq? @function.method.builtin "require"))

"defined?" @function.method.builtin

(call
  method: [(identifier) (constant)] @function.method)

; Function definitions

(alias (identifier) @function.method)
(setter (identifier) @function.method)
(method name: [(identifier) (constant)] @function.method)
(singleton_method name: [(identifier) (constant)] @function.method)

; Identifiers

[
  (class_variable)
  (instance_variable)
] @property

((identifier) @constant.builtin
 (#match? @constant.builtin "^__(FILE|LINE|ENCODING)__$"))

((constant) @constant
 (#match? @constant "^[A-Z\\d_]+$"))

(constant) @constructor

(self) @variable.builtin
(super) @variable.builtin

(block_parameter (identifier) @variable.parameter)
(block_parameters (identifier) @variable.parameter)
(destructured_parameter (identifier) @variable.parameter)
(hash_splat_parameter (identifier) @variable.parameter)
(lambda_parameters (identifier) @variable.parameter)
(method_parameters (identifier) @variable.parameter)
(splat_parameter (identifier) @variable.parameter)

(keyword_parameter name: (identifier) @variable.parameter)
(optional_parameter name: (identifier) @variable.parameter)

((identifier) @function.method
 (#is-not? local))
(identifier) @variable

; Literals

[
  (string)
  (bare_string)
  (subshell)
  (heredoc_body)
  (heredoc_beginning)
] @string

[
  (simple_symbol)
  (delimited_symbol)
  (hash_key_symbol)
  (bare_symbol)
] @string.special.symbol

(regex) @string.special.regex
(escape_sequence) @escape

[
  (integer)
  (float)
] @number

[
  (nil)
  (true)
  (false)
]@constant.builtin

(interpolation
  "#{" @punctuation.special
  "}" @punctuation.special) @embedded

(comment) @comment

; Operators

[
"="
"=>"
"->"
] @operator

[
  ","
  ";"
  "."
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "%w("
  "%i("
] @punctuation.bracket
'
]

{ #category : #configuration }
SBMetaBlockFactory >> addDelimitedRules: aCollection [

	delimitedRules addAll: aCollection
]

{ #category : #accessing }
SBMetaBlockFactory >> aliases [

	^ aliases
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> allSymbolsProducedBy: anObject on: aStream [

	(#('PREC' 'REPEAT' 'FIELD' 'REPEAT1') includes: anObject type) ifTrue: [^ self allSymbolsProducedBy: anObject content on: aStream].
	(#('STRING' 'PATTERN' 'BLANK') includes: anObject type) ifTrue: [^ self].
	
	anObject type caseOf: {
		['CHOICE'] -> [anObject members do: [:m | self allSymbolsProducedBy: m on: aStream]].
		['SYMBOL'] -> [aStream nextPut: anObject name].
		['ALIAS'] -> [aStream nextPut: anObject value].
		['SEQ'] -> [anObject members do: [:member | self allSymbolsProducedBy: member on: aStream]]}
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> applyInlining: rule [

	(rule type = 'SYMBOL' and: [
		(grammar inline includes: rule name) and: [
			SBToggledCode
				comment: ''
				active: 2
				do: {[true]. [(grammar supertypes includes: rule name) not]}]]) ifTrue: [ | inline |
		inline := grammar rules at: rule name.
		SBToggledCode comment: '' active: 1 do: {
			[
				rule removeAll.
				inline keysAndValuesDo: [:k :v | rule at: k put: v]].
			[ | symbols |
				symbols := (Array streamContents: [:stream | self symbolsProducedBy: inline on: stream]) asSet.
				symbols size = 1 ifTrue: [rule name: symbols anyOne] ifFalse: [
					rule
						type: 'CHOICE';
						members: (symbols collect: [:m | JsonObject fromAssociations: {'name' -> m. 'type' -> 'SYMBOL'}] as: Array)]]}.
		^ self].
	
	(rule type = 'SYMBOL' and: [rule name first = $_ and: [(grammar externals noneSatisfy: [:e | e name = rule name]) and: [(grammar supertypes includes: rule name) not]]]) ifTrue: [ | inline |
		inline := grammar rules at: rule name.
		(self includesNonHiddenParts: inline visited: Set new) ifTrue: [
			rule removeAll.
			inline keysAndValuesDo: [:key :val | rule at: key put: val]].
		^ self].
	
	rule content ifNotNil: [:c | self applyInlining: c].
	rule members ifNotNil: [:c | c do: [:child | self applyInlining: child]]
]

{ #category : #templates }
SBMetaBlockFactory >> at: aString putTemplate: aBlock [

	templateCache at: aString put: aBlock
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> autofixExternals [

	| externals |
	externals := (grammar externals select: [:rule | rule type = 'SYMBOL']) collect: #name.
	
	externals do: [:external |
		grammar rules keysAndValuesDo: [:name :rule |
			self
				traverse: rule
				detect: [:obj | obj type = 'ALIAS' and: obj content name = external]
				ifFound: [:obj |
					self grammar rules
						at: external
						put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> obj value})]
				ifNone: []]].
	
	(grammar externals select: [:rule | rule type = 'STRING']) do: [:external |
		self grammar rules
			at: external
			put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> external value})].
	
	(externals reject: [:external | grammar rules includesKey: external]) ifNotEmpty: [:missing | UIManager default inform: 'Missing declarations for: ', (missing joinSeparatedBy: ', ')]
]

{ #category : #configuration }
SBMetaBlockFactory >> blockInline: aCollection [

	blockInline := aCollection
]

{ #category : #helper }
SBMetaBlockFactory >> buildBlocksFor: anObject parentFieldName: aString visitedSymbols: aSet [

	anObject type = 'FIELD' ifTrue: [^ self buildBlocksFor: anObject content parentFieldName: anObject name visitedSymbols: aSet].
	
	(self unpackTypes includes: anObject type) ifTrue: [^ self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet].
	
	(#('STRING') includes: anObject type) ifTrue: [
		^ SBInlineBlockLabel new
			label: anObject value;
			factory: self].
	
	(#('PATTERN' 'TOKEN' 'IMMEDIATE_TOKEN') includes: anObject type) ifTrue: [
		^ SBInlineBlockText new
			regexString: (self buildRegexString: anObject);
			factory: self].
	
	(#('SYMBOL') includes: anObject type) ifTrue: [
		^ SBInlineBlockSymbol new
			type: anObject name factory: self visitedSymbols: aSet;
			field: aString;
			factory: self].
	
	'REPEAT' = anObject type ifTrue: [
		^ SBInlineBlockRepeat new
			multiple: true
				required: false
				element: (self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet);
			factory: self].
	
	'REPEAT1' = anObject type ifTrue: [
		^ SBInlineBlockRepeat new
			multiple: true
				required: true
				element: (self buildBlocksFor: anObject content parentFieldName: aString visitedSymbols: aSet);
			factory: self].
	
	'CHOICE' = anObject type ifTrue: [
		(anObject members size = 2 and: [anObject members second type = 'BLANK']) ifTrue: [
			^ SBInlineBlockRepeat new
				multiple: false
					required: false
					element: (self buildBlocksFor: anObject members first parentFieldName: aString visitedSymbols: aSet);
				factory: self].
		
		^ SBInlineBlockChoice new
			alternatives: (anObject members collect: [:member | self buildBlocksFor: member parentFieldName: aString visitedSymbols: aSet]);
			factory: self].
	
	'SEQ' = anObject type ifTrue: [
		^ SBInlineBlockSequence new
			factory: self;
			elements: (anObject members collect: [:member | self buildBlocksFor: member parentFieldName: aString visitedSymbols: aSet])].
	
	self assert: false
]

{ #category : #helper }
SBMetaBlockFactory >> buildRegex: anObject on: aStream [

	(self unpackTypes includes: (anObject at: #type)) ifTrue: [^ self buildRegex: anObject content on: aStream].
	
	(anObject at: #type) caseOf: {
		['TOKEN'] -> [self buildRegex: anObject content on: aStream].
		['IMMEDIATE_TOKEN'] -> [self buildRegex: anObject content on: aStream].
		['REPEAT'] -> [
			self buildRegex: anObject content on: aStream.
			aStream nextPut: $*].
		['REPEAT1'] -> [
			self buildRegex: anObject content on: aStream.
			aStream nextPut: $+].
		['PATTERN'] -> [
			aStream nextPut: $(.
			aStream nextPutAll: (anObject at: #value).
			aStream nextPut: $)].
		['CHOICE'] -> [
			aStream nextPut: $(.
			anObject members
				do: [:c | self buildRegex: c on: aStream]
				separatedBy: [aStream nextPut: $|].
			aStream nextPut: $)].
		['SEQ'] -> [anObject members do: [:c | self buildRegex: c on: aStream]].
		['STRING'] -> [
			aStream nextPut: $(.
			aStream nextPutAll: (self escapeStringForRegex: (anObject at: #value)).
			aStream nextPut: $)].
		['BLANK'] -> []}
]

{ #category : #helper }
SBMetaBlockFactory >> buildRegexString: rule [

	| s |
	s := '' writeStream.
	self buildRegex: rule on: s.
	^ (s contents copyReplaceAll: '\p{XID_Start}' with: 'A-Za-z')
		copyReplaceAll: '\p{XID_Continue}'
		with: 'A-Za-z0-9'
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> checkStructure: anObject [

	self assert: (anObject type ~= 'CHOICE' or: [anObject members size > 0]).
	
	anObject content ifNotNil: [:c | self checkStructure: c].
	anObject members ifNotNil: [:c | c do: [:m | self checkStructure: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> cleanGrammar [

	SBToggledCode comment: '' active: 1 do: {[self autofixExternals]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeExternals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeHiddenTerminals: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self simplifyList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules keysAndValuesDo: [:name :rule | self flattenSeparatedList: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules keysAndValuesDo: [:name :rule | self applyInlining: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeRedundantRepeats: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeAliases: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self unwrapSingleChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeOptionalRepeat: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self removeDuplicateAlternatives: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeNestedChoices: rule]]}.
	SBToggledCode
		comment: ''
		active: 1
		do: {[grammar rules do: [:rule | self mergeAdjacentOptions: rule]]}.
	grammar rules do: [:rule | self checkStructure: rule]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> deepCompare: anObject to: anotherObject [

	anObject associationsDo: [:assoc | | obj |
		obj := anotherObject at: assoc key ifAbsent: [^ false].
		((obj isDictionary and: [assoc value isDictionary])
			ifTrue: [self deepCompare: assoc value to: obj]
			ifFalse: [obj = assoc value]) ifFalse: [^ false]].
	^ true
]

{ #category : #configuration }
SBMetaBlockFactory >> delimitedRules [

	^ delimitedRules
]

{ #category : #configuration }
SBMetaBlockFactory >> delimitedRules: aDictionary [
	" ruleName -> delimiterString, e.g. 'parameters'->',' "

	delimitedRules := aDictionary
]

{ #category : #helper }
SBMetaBlockFactory >> escapeStringForRegex: aString [

	^ aString copyWithRegex: '[.*+?^${}:()|\[\]\\]' matchesTranslatedUsing: [:m | '\', m]
]

{ #category : #accessing }
SBMetaBlockFactory >> extras [

	^ extras
]

{ #category : #accessing }
SBMetaBlockFactory >> extras: aCollection [
	" a list of rules that are considered extras in TS, meaning comments and whitespaces "

	extras := aCollection
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> flattenSeparatedList: anObject [

	| looksLikeSepList looksLikeOptionalSep |
	looksLikeSepList := [:obj | obj type = 'SEQ' and: [obj members size = 2 and: [obj members second type = 'REPEAT' and: [obj members second content type = 'SEQ' and: [self deepCompare: obj members first to: obj members second content members second]]]]].
	looksLikeOptionalSep := [:obj | obj type = 'CHOICE' and: [obj members second type = 'BLANK' and: [obj members first type = 'STRING']]].
	
	" seq(seq(rule, repeat(seq(separator, rule))), (separator|blank)) "
	(anObject type = 'SEQ' and: [(looksLikeSepList value: anObject members first) and: [looksLikeOptionalSep value: anObject members second]]) ifTrue: [
		^ anObject
			type: 'REPEAT';
			content: anObject members first members first;
			removeKey: #members].
	
	" seq(rule, repeat(seq(separator, rule))) "
	(looksLikeSepList value: anObject) ifTrue: [
		^ anObject
			type: 'REPEAT';
			content: anObject members first;
			removeKey: #members].
	
	anObject content ifNotNil: [:c | self flattenSeparatedList: c].
	anObject members ifNotNil: [:c | c do: [:m | self flattenSeparatedList: m]]
]

{ #category : #helper }
SBMetaBlockFactory >> fullTokensInclude: aString [

	templateCache do: [:rule | rule allElementsDo: [:m | ((m isKindOf: SBInlineBlockLabel) and: [aString = m label]) ifTrue: [^ true]]].
	^ false
]

{ #category : #templates }
SBMetaBlockFactory >> getTemplate: aTypeString [

	^ self getTemplate: aTypeString ifAbsent: [self assert: false]
]

{ #category : #templates }
SBMetaBlockFactory >> getTemplate: aTypeString ifAbsent: aBlock [

	^ templateCache at: aTypeString ifAbsent: [ | rule |
		rule := grammar rules at: aTypeString ifAbsent: [
			(aliases anySatisfy: [:pair | pair key = aTypeString]) ifTrue: [^ 'ALIAS'].
			^ aBlock value].
		
		" reserve spot in case of recursion "
		templateCache at: aTypeString put: nil.
		
		templateCache
			at: aTypeString
			put: (self buildBlocksFor: rule parentFieldName: nil visitedSymbols: Set new)]
]

{ #category : #accessing }
SBMetaBlockFactory >> grammar [

	^ grammar
]

{ #category : #accessing }
SBMetaBlockFactory >> grammar: aJsonObject [

	grammar := aJsonObject
]

{ #category : #accessing }
SBMetaBlockFactory >> grammarHandler [

	^ SBMetaGrammarHandler new
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> hardLineBreakMatch: aBlock [

	^ hardLineBreakMatcher ifNotNil: [:b | b value: aBlock] ifNil: [false]
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> hardLineBreakMatcher [

	^ hardLineBreakMatcher
]

{ #category : #configuration }
SBMetaBlockFactory >> hardLineBreakMatcher: aBlock [

	hardLineBreakMatcher := aBlock
]

{ #category : #testing }
SBMetaBlockFactory >> hasHighlight [

	^ highlightQuery notNil
]

{ #category : #accessing }
SBMetaBlockFactory >> highlightQuery [

	^ highlightQuery
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> ignoreExternals: aCollection [

	aCollection do: [:name |
		self grammar rules
			at: name
			put: (JsonObject fromAssociations: {'type' -> 'STRING'. 'value' -> ''})]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> includesNonHiddenParts: anObject visited: aCollection [

	(#('PREC' 'PREC_DYNAMIC' 'PREC_LEFT' 'PREC_RIGHT' 'REPEAT' 'FIELD' 'REPEAT1') includes: anObject type) ifTrue: [^ self includesNonHiddenParts: anObject content visited: aCollection].
	(#('STRING' 'PATTERN' 'BLANK' 'TOKEN') includes: anObject type) ifTrue: [^ false].
	
	^ anObject type caseOf: {
		['CHOICE'] -> [anObject members anySatisfy: [:m | self includesNonHiddenParts: m visited: aCollection]].
		['SYMBOL'] -> [
			anObject name first ~= $_ ifTrue: [^ true].
			(aCollection includes: anObject name) ifTrue: [false] ifFalse: [
				aCollection add: anObject name.
				self includesNonHiddenParts: (grammar rules at: anObject name) visited: aCollection]].
		['ALIAS'] -> [
			anObject value first ~= $_ ifTrue: [^ true].
			(aCollection includes: anObject value) ifTrue: [false] ifFalse: [
				aCollection add: anObject value.
				grammar rules
					at: anObject value
					ifPresent: [:r | self includesNonHiddenParts: r visited: aCollection]
					ifAbsent: [false]]].
		['SEQ'] -> [anObject members anySatisfy: [:member | self includesNonHiddenParts: member visited: aCollection]]}
]

{ #category : #'initialize-release' }
SBMetaBlockFactory >> initialize [

	super initialize.
	
	templateCache := Dictionary new.
	aliases := OrderedCollection new.
	blockInline := {}.
	statementContainerTypes := {}.
	supertypes := {}.
	noteUncapturedText := #().
	hardLineBreakMatcher := [:block | false].
	delimitedRules := Dictionary new
]

{ #category : #templates }
SBMetaBlockFactory >> instantiateTemplate: aString [

	^ (self getTemplate: aString) buildEmpty buildDefault
]

{ #category : #templates }
SBMetaBlockFactory >> instantiateToplevel: aString [

	^ SBInlineBlockSymbol new
		type: aString factory: self block: (self instantiateTemplate: aString);
		attachDecorator: SBResizableDecorator new;
		hResizing: #rigid;
		updateAllHighlights
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> isStatementContainer: aString [

	^ statementContainerTypes includes: aString
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> isSuperType: aTypeString [

	^ supertypes includes: aTypeString
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeAdjacentOptions: anObject [
	" look for (element | element*) and change to element+ "

	anObject type = 'CHOICE' ifTrue: [
		anObject members copy do: [:alt |
			((alt type beginsWith: 'REPEAT') and: [alt content type = 'SYMBOL']) ifTrue: [
				anObject members do: [:otherAlt |
					(otherAlt type = 'SYMBOL' and: [alt content name = otherAlt name]) ifTrue: [
						alt type: 'REPEAT1'.
						anObject members: (anObject members copyWithout: otherAlt)]]]]].
	
	anObject content ifNotNil: [:c | self mergeNestedChoices: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeNestedChoices: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeNestedChoices: anObject [

	anObject type = 'CHOICE' ifTrue: [
		(anObject members noneSatisfy: [:m | m type = 'BLANK']) ifTrue: [
			anObject members: (Array streamContents: [:stream |
				anObject members do: [:nested |
					(nested type = 'CHOICE' and: [nested members noneSatisfy: [:m | m type = 'BLANK']])
						ifTrue: [stream nextPutAll: nested members]
						ifFalse: [stream nextPut: nested]]])]].
	
	anObject content ifNotNil: [:c | self mergeNestedChoices: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeNestedChoices: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeOptionalRepeat: anObject [

	(anObject type = 'CHOICE' and: [anObject members size = 2 and: [(anObject members first type beginsWith: 'REPEAT') and: [anObject members second type = 'BLANK']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
		anObject type: 'REPEAT'].
	
	((anObject type beginsWith: 'REPEAT') and: [anObject content type = 'CHOICE' and: [anObject content members size = 2 and: [anObject content members second type = 'BLANK']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject content members first.
		anObject removeAll.
		anObject content: copyFrom.
		anObject type: 'REPEAT'].
	
	anObject content ifNotNil: [:c | self mergeOptionalRepeat: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeOptionalRepeat: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeRedundantRepeats: anObject [

	(anObject type = 'REPEAT' and: [anObject content type = 'CHOICE']) ifTrue: [
		anObject content members do: [:m |
			(m type = 'REPEAT' or: [m type = 'REPEAT1']) ifTrue: [ | copyFrom |
				copyFrom := m content.
				m removeAll.
				copyFrom keysAndValuesDo: [:key :val | m at: key put: val]]]].
	
	anObject content ifNotNil: [:c | self mergeRedundantRepeats: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeRedundantRepeats: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> mergeRepeats: anObject [

	(anObject type = 'SEQ' and: [anObject members size = 2 and: [anObject members first type = 'SYMBOL' and: [(anObject members last type = 'REPEAT' and: [anObject members last content type = 'SYMBOL']) and: [anObject members last content name = anObject members first name]]]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members last.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
		anObject type: 'REPEAT1'].
	
	
	anObject content ifNotNil: [:c | self mergeRepeats: c].
	anObject members ifNotNil: [anObject members do: [:m | self mergeRepeats: m]]
]

{ #category : #accessing }
SBMetaBlockFactory >> name: aSymbol preprocess: aBlock postprocess: anotherBlock grammar: aString highlight: anotherString [

	grammar := Json readFrom: aString readStream.
	supertypes := grammar supertypes.
	name := aSymbol.
	highlightQuery := SBTSQuery new prepare: anotherString.
	extras := grammar extras
		select: [:rule | rule type = 'SYMBOL']
		thenCollect: [:rule | rule name].
	self wordRule: grammar word.
	
	aBlock cull: self.
	self cleanGrammar.
	anotherBlock cull: self.
	
	" make sure all rules are in the cache "
	grammar rules keysAndValuesDo: [:name :r | self getTemplate: name]
]

{ #category : #configuration }
SBMetaBlockFactory >> noteUncapturedText [

	^ noteUncapturedText
]

{ #category : #configuration }
SBMetaBlockFactory >> noteUncapturedText: aCollection [

	noteUncapturedText := aCollection
]

{ #category : #templates }
SBMetaBlockFactory >> parse: aString [

	^ SBTreeSitter new parse: aString language: name factory: self
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeAliases: anObject [

	SBToggledCode comment: '' active: 1 do: {
		[
			anObject type = 'ALIAS' ifTrue: [ | copyFrom |
				aliases add: anObject value -> anObject content veryDeepCopy.
				
				copyFrom := anObject content.
				anObject removeAll.
				copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
				^ self]].
		[
			anObject type = 'ALIAS' ifTrue: [
				anObject type: 'SYMBOL'.
				anObject name: anObject value.
				anObject removeKey: 'value'.
				anObject removeKey: 'named'.
				anObject removeKey: 'content'.
				^ self]]}.
	
	anObject content ifNotNil: [:c | self removeAliases: c].
	anObject members ifNotNil: [:c | c do: [:m | self removeAliases: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeDuplicateAlternatives: anObject [
	" TODO: only removes SYMBOL duplicates "

	(anObject type = 'CHOICE' and: [anObject members allSatisfy: [:m | m type = 'SYMBOL']]) ifTrue: [ | symbols |
		symbols := anObject members collect: #name.
		symbols size ~= symbols asSet size ifTrue: [
			anObject members: anObject members withoutDuplicates]].
	anObject content ifNotNil: [self removeDuplicateAlternatives: anObject content].
	anObject members ifNotNil: [anObject members do: [:m | self removeDuplicateAlternatives: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeExternals: anObject [

	anObject content ifNotNil: [:c | self removeExternals: c].
	anObject members ifNotNil: [
		anObject members: (anObject members copyWithoutAll: (Array streamContents: [:stream | anObject members do: [:member | (member type = 'SYMBOL' and: [grammar externals anySatisfy: [:external | external name = member name]]) ifTrue: [stream nextPut: member]]])).
		anObject members do: [:m | self removeExternals: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeHiddenTerminals: anObject [

	anObject content ifNotNil: [:c | self removeHiddenTerminals: c].
	anObject members ifNotNil: [
		anObject members: (anObject members copyWithoutAll: (Array streamContents: [:stream | anObject members do: [:member | ((member type = 'SYMBOL' and: [(self includesNonHiddenParts: member visited: Set new) not]) or: [anObject type = 'SEQ' and: [member type = 'BLANK']]) ifTrue: [stream nextPut: member]]])).
		anObject members do: [:m | self removeHiddenTerminals: m]]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeOptionalString: aString in: anObject [

	(anObject type = 'SEQ' and: [
		anObject members last type = 'CHOICE' and: [ | choices |
			choices := anObject members last members.
			choices size = 2 and: [choices second type = 'BLANK' and: [choices first type = 'STRING' and: [choices first value = aString]]]]]) ifTrue: [
		anObject members size = 2
			ifTrue: [anObject members last members: (anObject members last members copyWithout: anObject members last members last)]
			ifFalse: [ | copyFrom |
				copyFrom := anObject members first.
				anObject removeAll.
				copyFrom keysAndValuesDo: [:key :value | anObject at: key put: value]]].
	anObject content ifNotNil: [:c | self removeOptionalString: aString in: c].
	anObject members ifNotNil: [:c | c do: [:m | self removeOptionalString: aString in: m]]
]

{ #category : #accessing }
SBMetaBlockFactory >> rootRuleName [

	^ rootRuleName
]

{ #category : #accessing }
SBMetaBlockFactory >> rootRuleName: aString [

	rootRuleName := aString
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> rule: aRule inlineIn: anObject [

	(anObject type = 'SYMBOL' and: [anObject name = aRule]) ifTrue: [ | copyFrom |
		copyFrom := grammar rules at: aRule.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val veryDeepCopy].
		^ self].
	
	anObject content ifNotNil: [:c | self rule: aRule inlineIn: c].
	anObject members ifNotNil: [anObject members do: [:m | self rule: aRule inlineIn: m]]
]

{ #category : #accessing }
SBMetaBlockFactory >> rulesDo: aBlock [

	self grammar rules keysAndValuesDo: [:name :rule | aBlock cull: rule cull: name]
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> shouldBlockInline: aTypeString [

	^ (self isSuperType: aTypeString) or: [blockInline includes: aTypeString]
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> simplifyList: anObject [
	" make a*? to a* "

	(anObject type = 'CHOICE' and: [anObject members size = 2 and: [anObject members last type = 'BLANK' and: [anObject members first type = 'REPEAT']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val]].
	
	anObject content ifNotNil: [:c | self simplifyList: c].
	anObject members ifNotNil: [anObject members do: [:m | self simplifyList: m]]
]

{ #category : #configuration }
SBMetaBlockFactory >> statementContainerTypes: aCollection [

	statementContainerTypes := aCollection
]

{ #category : #configuration }
SBMetaBlockFactory >> supertypes: aCollection [

	supertypes := aCollection
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> symbolsProducedBy: anObject on: aStream [

	(#('PREC' 'FIELD') includes: anObject type) ifTrue: [^ self symbolsProducedBy: anObject content on: aStream].
	
	anObject type caseOf: {
		['CHOICE'] -> [anObject members do: [:m | self symbolsProducedBy: m on: aStream]].
		['STRING'] -> [].
		['SYMBOL'] -> [aStream nextPut: anObject name].
		['ALIAS'] -> [aStream nextPut: anObject value].
		['SEQ'] -> [ | nonHidden |
			self assert: (anObject members allSatisfy: [:m | m type = 'SYMBOL']).
			nonHidden := anObject members select: [:m | m name first ~= $_].
			self assert: nonHidden size = 1.
			aStream nextPut: nonHidden first name value]}
]

{ #category : #templates }
SBMetaBlockFactory >> toplevel [

	^ self instantiateToplevel: self rootRuleName
]

{ #category : #helper }
SBMetaBlockFactory >> traverse: anObject detect: aBlock ifFound: aSuccessBlock ifNone: aFailBlock [

	self traverse: anObject do: [:block | (aBlock value: block) ifTrue: [^ aSuccessBlock value: block]].
	^ aFailBlock value
]

{ #category : #helper }
SBMetaBlockFactory >> traverse: anObject do: aBlock [

	aBlock value: anObject.
	anObject members ifNotNil: [:m | m do: [:member | self traverse: member do: aBlock]].
	anObject content ifNotNil: [:content | self traverse: content do: aBlock]
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> type: aRuleName compatibleWith: anotherRuleName [

	(aRuleName isNil and: [anotherRuleName isNil]) ifTrue: [^ true].
	
	anotherRuleName isString ifFalse: [^ anotherRuleName anySatisfy: [:r | self type: aRuleName compatibleWith: r]].
	
	^ aRuleName = anotherRuleName or: [ | template |
		template := self getTemplate: anotherRuleName.
		(template isKindOf: SBInlineBlockChoice) and: [template alternatives anySatisfy: [:t |
				(t isKindOf: SBInlineBlockSymbol)
					ifTrue: [self type: aRuleName compatibleWith: t type]
					ifFalse: [(t isKindOf: SBInlineBlockChoice)
							ifTrue: [t alternatives anySatisfy: [:a | (a isKindOf: SBInlineBlockSymbol) and: [self type: aRuleName compatibleWith: a type]]]
							ifFalse: [false]]]]]
]

{ #category : #helper }
SBMetaBlockFactory >> unpackTypes [

	^ #('PREC_RIGHT' 'PREC_LEFT' 'PREC_DYNAMIC' 'PREC' 'ALIAS' 'FIELD')
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> unwrapSingleChoices: anObject [

	(((anObject type = 'CHOICE' or: [anObject type = 'SEQ']) and: [anObject members size = 1]) or: [anObject type = 'CHOICE' and: [anObject members size = 2 and: [anObject members first type = 'REPEAT' and: [anObject members second type = 'BLANK']]]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val]].
	
	anObject content ifNotNil: [:c | self unwrapSingleChoices: c].
	anObject members ifNotNil: [anObject members do: [:m | self unwrapSingleChoices: m]]
]

{ #category : #accessing }
SBMetaBlockFactory >> wordRule [

	^ wordRule
]

{ #category : #accessing }
SBMetaBlockFactory >> wordRule: aString [

	aString ifNotNil: [
		wordRule := (self buildRegexString: (grammar rules at: aString)) asRegex]
]
