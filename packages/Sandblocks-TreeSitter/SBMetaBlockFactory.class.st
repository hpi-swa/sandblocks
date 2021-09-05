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
		'highlightQuery'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaBlockFactory class >> json [

	^ SBMetaBlockFactory new
		name: #json
		preprocess: []
		postprocess: [:f | f blockInline: {'string_content'}]
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

{ #category : #'as yet unclassified' }
SBMetaBlockFactory class >> python [
	" https://github.com/tree-sitter/tree-sitter-python/blob/master/src/grammar.json "

	^ SBMetaBlockFactory new
		name: #python
		preprocess: [:f | ]
		postprocess: [:f |
			f statementContainerTypes: #('block').
			f blockInline: {'expression_statement'. 'parameters'}.
			f rulesDo: [:r | f removeOptionalString: ',' in: r].
			f grammar rules
				at: '"'
				put: (JsonObject fromAssociations: {#type -> 'STRING'. #value -> '"'}).
			f hardLineBreakMatcher: [:b | ((b isKindOf: SBInlineBlockLabel) and: [b label = ':']) or: [(b parentSandblock isKindOf: SBInlineBlockSymbol) and: [{'block'. 'module'} includes: b parentSandblock type]]]]
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
				do: {[true]. [(grammar supertypes includes: rule name) not]}]]) ifTrue: [ | inline symbols |
		inline := grammar rules at: rule name.
		rule name = 'expression_statement' ifTrue: [self halt].
		symbols := (Array streamContents: [:stream | self symbolsProducedBy: inline on: stream]) asSet.
		symbols size = 1 ifTrue: [rule name: symbols anyOne] ifFalse: [
			rule
				type: 'CHOICE';
				members: (symbols collect: [:m | JsonObject fromAssociations: {'name' -> m. 'type' -> 'SYMBOL'}] as: Array)].
		^ self].
	
	(rule type = 'SYMBOL' and: [rule name first = $_ and: [(grammar externals noneSatisfy: [:e | e name = rule name]) and: [(grammar supertypes includes: rule name) not]]]) ifTrue: [ | inline symbols |
		inline := grammar rules at: rule name.
		(self includesNonHiddenParts: inline visited: Set new) ifTrue: [
			symbols := (Array streamContents: [:stream | self allSymbolsProducedBy: inline on: stream]) asSet.
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
SBMetaBlockFactory >> cleanGrammar [

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
		do: {[grammar rules do: [:rule | self removeDuplicateAlternatives: rule]]}
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

{ #category : #helper }
SBMetaBlockFactory >> escapeStringForRegex: aString [

	^ aString copyWithRegex: '[.*+?^${}()|\[\]\\]' matchesTranslatedUsing: [:m | '\', m]
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

{ #category : #templates }
SBMetaBlockFactory >> getTemplate: aTypeString [

	^ templateCache at: aTypeString ifAbsent: [
		" reserve spot in case of recursion "
		templateCache at: aTypeString put: nil.
		templateCache at: aTypeString put: (self
			buildBlocksFor: (grammar rules at: aTypeString ifAbsent: [self assert: false])
			parentFieldName: nil
			visitedSymbols: Set new)]
]

{ #category : #accessing }
SBMetaBlockFactory >> grammar [

	^ grammar
]

{ #category : #accessing }
SBMetaBlockFactory >> grammarHandler [

	^ SBMetaGrammarHandler new
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> hardLineBreakMatcher [

	^ hardLineBreakMatcher
]

{ #category : #configuration }
SBMetaBlockFactory >> hardLineBreakMatcher: aBlock [

	hardLineBreakMatcher := aBlock
]

{ #category : #accessing }
SBMetaBlockFactory >> highlightQuery [

	^ highlightQuery
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
	blockInline := {}.
	statementContainerTypes := {}.
	supertypes := {}.
	hardLineBreakMatcher := [:block | false]
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
SBMetaBlockFactory >> mergeOptionalRepeat: anObject [

	(anObject type = 'CHOICE' and: [anObject members size = 2 and: [(anObject members first type beginsWith: 'REPEAT') and: [anObject members second type = 'BLANK']]]) ifTrue: [ | copyFrom |
		copyFrom := anObject members first.
		anObject removeAll.
		copyFrom keysAndValuesDo: [:key :val | anObject at: key put: val].
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
	
	aBlock cull: self.
	self cleanGrammar.
	anotherBlock cull: self
]

{ #category : #templates }
SBMetaBlockFactory >> parse: aString [

	^ SBTreeSitter new parse: aString language: name factory: self
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> removeAliases: anObject [

	anObject type = 'ALIAS' ifTrue: [
		anObject type: 'SYMBOL'.
		anObject name: anObject value.
		anObject removeKey: 'value'.
		anObject removeKey: 'named'.
		anObject removeKey: 'content'.
		^ self].
	
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
SBMetaBlockFactory >> simplifyGrammar [

	
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
		do: {[grammar rules do: [:rule | self flattenSeparatedList: rule]]}.
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
		do: {[grammar rules do: [:rule | self mergeOptionalRepeat: rule]]}
]

{ #category : #'grammar clean' }
SBMetaBlockFactory >> simplifyList: anObject [

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

	(#('PREC') includes: anObject type) ifTrue: [^ self symbolsProducedBy: anObject content on: aStream].
	
	anObject type caseOf: {
		['CHOICE'] -> [anObject members do: [:m | self symbolsProducedBy: m on: aStream]].
		['SYMBOL'] -> [aStream nextPut: anObject name].
		['ALIAS'] -> [aStream nextPut: anObject value].
		['SEQ'] -> [ | nonHidden |
			self assert: (anObject members allSatisfy: [:m | m type = 'SYMBOL']).
			nonHidden := anObject members select: [:m | m name first ~= $_].
			self assert: nonHidden size = 1.
			aStream nextPut: nonHidden first name value]}
]

{ #category : #'configuration helpers' }
SBMetaBlockFactory >> type: aRuleName compatibleWith: anotherRuleName [

	(aRuleName isNil and: [anotherRuleName isNil]) ifTrue: [^ true].
	
	anotherRuleName isString ifFalse: [^ anotherRuleName anySatisfy: [:r | self type: aRuleName compatibleWith: r]].
	
	^ aRuleName = anotherRuleName or: [ | template |
		template := self getTemplate: anotherRuleName.
		(template isKindOf: SBInlineBlockChoice) and: [template alternatives anySatisfy: [:t | (t isKindOf: SBInlineBlockSymbol) and: [self type: aRuleName compatibleWith: t type]]]]
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
