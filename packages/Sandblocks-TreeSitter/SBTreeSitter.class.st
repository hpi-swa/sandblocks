Class {
	#name : #SBTreeSitter,
	#superclass : #ExternalLibrary,
	#instVars : [
		'currentString',
		'currentFactory'
	],
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBTreeSitter class >> moduleName [

	^ 'tree-sitter'
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> currentFactory [

	^ currentFactory
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursor: aCursor reset: aNode [

	<apicall: void ts_tree_cursor_reset (SBTSTreeCursor* SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorCopy: aCursor [

	<apicall: SBTSTreeCursor ts_tree_cursor_copy (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorCurrentNode: aCursor [

	<apicall: SBTSNode ts_tree_cursor_current_node (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorDelete: aCursor [

	<apicall: void ts_tree_cursor_delete (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorGotoFirstChild: aCursor [

	<apicall: bool ts_tree_cursor_goto_first_child (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorGotoNextSibling: aCursor [

	<apicall: bool ts_tree_cursor_goto_next_sibling (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorGotoParent: aCursor [

	<apicall: bool ts_tree_cursor_goto_parent (SBTSTreeCursor*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> cursorNew: root [

	<apicall: SBTSTreeCursor ts_tree_cursor_new (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> jsonFactory [

	^ (SBMetaBlockFactory new
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
		nodeTypes: '{}') in: [:f |
		f cleanGrammar.
		f grammar blockInline: {'string_content'}.
		f]
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> node: aNode childByFieldName: aString length: aNumber [

	<apicall: SBTSNode ts_node_child_by_field_name (SBTSNode char* uint32_t)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> nodeEndByte: aNode [

	<apicall: uint32_t ts_node_end_byte (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> nodeParent: aNode [

	<apicall: SBTSNode ts_node_parent (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> nodeStartByte: aNode [

	<apicall: uint32_t ts_node_start_byte (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> nodeString: aNode [

	<apicall: char* ts_node_string (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> nodeType: aNode [

	<apicall: char* ts_node_type (SBTSNode)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parse: aString language: aSymbol [

	| language parser root tree block cursor |
	currentString := aString withUnixLineEndings.
	currentFactory := self perform: (aSymbol, 'Factory') asSymbol.
	language := self perform: aSymbol.
	
	parser := self parserNew.
	self parser: parser setLanguage: language.
	
	tree := self parser: parser old: nil parseString: currentString length: currentString size.
	
	root := self treeRootNode: tree.
	cursor := self cursorNew: root.
	
	block := ((SBInlineBlockSymbol new
		type: (self nodeType: root)
		factory: currentFactory) takeParsedFrom: (SBTSCursor new library: self cursor: cursor))
		hResizing: #rigid;
		attachDecorator: SBResizableDecorator new.
	
	self cursorDelete: cursor.
	self parserDelete: parser.
	
	^ block
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parser: aParserPointer old: aTreePointer parseString: aString length: aNumber [

	<apicall: void* ts_parser_parse_string (void* void* char* uint32_t)> 
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parser: aParserPointer setLanguage: aLanguagePointer [

	<apicall: void ts_parser_set_language (void* void*)> 
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parserDelete: aCursor [

	<apicall: void ts_parser_delete (void*)>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> parserNew [

	<apicall: void* ts_parser_new ()> 
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> printTree: aCursor factory: aFactory [

	| node type rule |
	node := self cursorCurrentNode: aCursor.
	type := self nodeType: node.
	rule := aFactory grammar rules at: type.
	
	Transcript showln: type.
	
	(self cursorGotoFirstChild: aCursor) ifTrue: [
		self printTree: aCursor factory: aFactory.
		[self cursorGotoNextSibling: aCursor] whileTrue: [self printTree: aCursor factory: aFactory].
		self cursorGotoParent: aCursor]
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> python [

	<apicall: void* tree_sitter_python () module: 'tree-sitter-python'>
	^ self externalCallFailed
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> pythonFactory [
	" https://github.com/tree-sitter/tree-sitter-python/blob/master/src/grammar.json
	  https://github.com/tree-sitter/tree-sitter-python/blob/master/src/node-types.json "

	^ (SBMetaBlockFactory new
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
		nodeTypes: '[
  {
    "type": "_compound_statement",
    "named": true,
    "subtypes": [
      {
        "type": "class_definition",
        "named": true
      },
      {
        "type": "decorated_definition",
        "named": true
      },
      {
        "type": "for_statement",
        "named": true
      },
      {
        "type": "function_definition",
        "named": true
      },
      {
        "type": "if_statement",
        "named": true
      },
      {
        "type": "try_statement",
        "named": true
      },
      {
        "type": "while_statement",
        "named": true
      },
      {
        "type": "with_statement",
        "named": true
      }
    ]
  },
  {
    "type": "_simple_statement",
    "named": true,
    "subtypes": [
      {
        "type": "assert_statement",
        "named": true
      },
      {
        "type": "break_statement",
        "named": true
      },
      {
        "type": "continue_statement",
        "named": true
      },
      {
        "type": "delete_statement",
        "named": true
      },
      {
        "type": "exec_statement",
        "named": true
      },
      {
        "type": "expression_statement",
        "named": true
      },
      {
        "type": "future_import_statement",
        "named": true
      },
      {
        "type": "global_statement",
        "named": true
      },
      {
        "type": "import_from_statement",
        "named": true
      },
      {
        "type": "import_statement",
        "named": true
      },
      {
        "type": "nonlocal_statement",
        "named": true
      },
      {
        "type": "pass_statement",
        "named": true
      },
      {
        "type": "print_statement",
        "named": true
      },
      {
        "type": "raise_statement",
        "named": true
      },
      {
        "type": "return_statement",
        "named": true
      }
    ]
  },
  {
    "type": "expression",
    "named": true,
    "subtypes": [
      {
        "type": "await",
        "named": true
      },
      {
        "type": "boolean_operator",
        "named": true
      },
      {
        "type": "comparison_operator",
        "named": true
      },
      {
        "type": "conditional_expression",
        "named": true
      },
      {
        "type": "lambda",
        "named": true
      },
      {
        "type": "named_expression",
        "named": true
      },
      {
        "type": "not_operator",
        "named": true
      },
      {
        "type": "primary_expression",
        "named": true
      }
    ]
  },
  {
    "type": "parameter",
    "named": true,
    "subtypes": [
      {
        "type": "default_parameter",
        "named": true
      },
      {
        "type": "dictionary_splat_pattern",
        "named": true
      },
      {
        "type": "identifier",
        "named": true
      },
      {
        "type": "list_splat_pattern",
        "named": true
      },
      {
        "type": "tuple_pattern",
        "named": true
      },
      {
        "type": "typed_default_parameter",
        "named": true
      },
      {
        "type": "typed_parameter",
        "named": true
      }
    ]
  },
  {
    "type": "pattern",
    "named": true,
    "subtypes": [
      {
        "type": "attribute",
        "named": true
      },
      {
        "type": "identifier",
        "named": true
      },
      {
        "type": "list_pattern",
        "named": true
      },
      {
        "type": "list_splat_pattern",
        "named": true
      },
      {
        "type": "subscript",
        "named": true
      },
      {
        "type": "tuple_pattern",
        "named": true
      }
    ]
  },
  {
    "type": "primary_expression",
    "named": true,
    "subtypes": [
      {
        "type": "attribute",
        "named": true
      },
      {
        "type": "binary_operator",
        "named": true
      },
      {
        "type": "call",
        "named": true
      },
      {
        "type": "concatenated_string",
        "named": true
      },
      {
        "type": "dictionary",
        "named": true
      },
      {
        "type": "dictionary_comprehension",
        "named": true
      },
      {
        "type": "ellipsis",
        "named": true
      },
      {
        "type": "false",
        "named": true
      },
      {
        "type": "float",
        "named": true
      },
      {
        "type": "generator_expression",
        "named": true
      },
      {
        "type": "identifier",
        "named": true
      },
      {
        "type": "integer",
        "named": true
      },
      {
        "type": "list",
        "named": true
      },
      {
        "type": "list_comprehension",
        "named": true
      },
      {
        "type": "none",
        "named": true
      },
      {
        "type": "parenthesized_expression",
        "named": true
      },
      {
        "type": "set",
        "named": true
      },
      {
        "type": "set_comprehension",
        "named": true
      },
      {
        "type": "string",
        "named": true
      },
      {
        "type": "subscript",
        "named": true
      },
      {
        "type": "true",
        "named": true
      },
      {
        "type": "tuple",
        "named": true
      },
      {
        "type": "unary_operator",
        "named": true
      }
    ]
  },
  {
    "type": "aliased_import",
    "named": true,
    "fields": {
      "alias": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "dotted_name",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "argument_list",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "dictionary_splat",
          "named": true
        },
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "keyword_argument",
          "named": true
        },
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "assert_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "assignment",
    "named": true,
    "fields": {
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "pattern",
            "named": true
          },
          {
            "type": "pattern_list",
            "named": true
          }
        ]
      },
      "right": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "assignment",
            "named": true
          },
          {
            "type": "augmented_assignment",
            "named": true
          },
          {
            "type": "expression",
            "named": true
          },
          {
            "type": "expression_list",
            "named": true
          },
          {
            "type": "yield",
            "named": true
          }
        ]
      },
      "type": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "type",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "attribute",
    "named": true,
    "fields": {
      "attribute": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "object": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "augmented_assignment",
    "named": true,
    "fields": {
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "pattern",
            "named": true
          },
          {
            "type": "pattern_list",
            "named": true
          }
        ]
      },
      "operator": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "%=",
            "named": false
          },
          {
            "type": "&=",
            "named": false
          },
          {
            "type": "**=",
            "named": false
          },
          {
            "type": "*=",
            "named": false
          },
          {
            "type": "+=",
            "named": false
          },
          {
            "type": "-=",
            "named": false
          },
          {
            "type": "//=",
            "named": false
          },
          {
            "type": "/=",
            "named": false
          },
          {
            "type": "<<=",
            "named": false
          },
          {
            "type": ">>=",
            "named": false
          },
          {
            "type": "@=",
            "named": false
          },
          {
            "type": "^=",
            "named": false
          },
          {
            "type": "|=",
            "named": false
          }
        ]
      },
      "right": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "assignment",
            "named": true
          },
          {
            "type": "augmented_assignment",
            "named": true
          },
          {
            "type": "expression",
            "named": true
          },
          {
            "type": "expression_list",
            "named": true
          },
          {
            "type": "yield",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "await",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "binary_operator",
    "named": true,
    "fields": {
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      },
      "operator": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "%",
            "named": false
          },
          {
            "type": "&",
            "named": false
          },
          {
            "type": "*",
            "named": false
          },
          {
            "type": "**",
            "named": false
          },
          {
            "type": "+",
            "named": false
          },
          {
            "type": "-",
            "named": false
          },
          {
            "type": "/",
            "named": false
          },
          {
            "type": "//",
            "named": false
          },
          {
            "type": "<<",
            "named": false
          },
          {
            "type": ">>",
            "named": false
          },
          {
            "type": "@",
            "named": false
          },
          {
            "type": "^",
            "named": false
          },
          {
            "type": "|",
            "named": false
          }
        ]
      },
      "right": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "block",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "_compound_statement",
          "named": true
        },
        {
          "type": "_simple_statement",
          "named": true
        }
      ]
    }
  },
  {
    "type": "boolean_operator",
    "named": true,
    "fields": {
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "operator": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "and",
            "named": false
          },
          {
            "type": "or",
            "named": false
          }
        ]
      },
      "right": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "break_statement",
    "named": true,
    "fields": {}
  },
  {
    "type": "call",
    "named": true,
    "fields": {
      "arguments": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "argument_list",
            "named": true
          },
          {
            "type": "generator_expression",
            "named": true
          }
        ]
      },
      "function": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "chevron",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "class_definition",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      },
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "superclasses": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "argument_list",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "comparison_operator",
    "named": true,
    "fields": {
      "operators": {
        "multiple": true,
        "required": true,
        "types": [
          {
            "type": "!=",
            "named": false
          },
          {
            "type": "<",
            "named": false
          },
          {
            "type": "<=",
            "named": false
          },
          {
            "type": "<>",
            "named": false
          },
          {
            "type": "==",
            "named": false
          },
          {
            "type": ">",
            "named": false
          },
          {
            "type": ">=",
            "named": false
          },
          {
            "type": "in",
            "named": false
          },
          {
            "type": "is",
            "named": false
          },
          {
            "type": "not",
            "named": false
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "primary_expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "concatenated_string",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "string",
          "named": true
        }
      ]
    }
  },
  {
    "type": "conditional_expression",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "continue_statement",
    "named": true,
    "fields": {}
  },
  {
    "type": "decorated_definition",
    "named": true,
    "fields": {
      "definition": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "class_definition",
            "named": true
          },
          {
            "type": "function_definition",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "decorator",
          "named": true
        }
      ]
    }
  },
  {
    "type": "decorator",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "primary_expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "default_parameter",
    "named": true,
    "fields": {
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "delete_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "expression_list",
          "named": true
        }
      ]
    }
  },
  {
    "type": "dictionary",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "dictionary_splat",
          "named": true
        },
        {
          "type": "pair",
          "named": true
        }
      ]
    }
  },
  {
    "type": "dictionary_comprehension",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "pair",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "for_in_clause",
          "named": true
        },
        {
          "type": "if_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "dictionary_splat",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "dictionary_splat_pattern",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "attribute",
          "named": true
        },
        {
          "type": "identifier",
          "named": true
        },
        {
          "type": "subscript",
          "named": true
        }
      ]
    }
  },
  {
    "type": "dotted_name",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "identifier",
          "named": true
        }
      ]
    }
  },
  {
    "type": "elif_clause",
    "named": true,
    "fields": {
      "condition": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "consequence": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "else_clause",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "except_clause",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "block",
          "named": true
        },
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "exec_statement",
    "named": true,
    "fields": {
      "code": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "string",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "expression_list",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "expression_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "assignment",
          "named": true
        },
        {
          "type": "augmented_assignment",
          "named": true
        },
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "yield",
          "named": true
        }
      ]
    }
  },
  {
    "type": "finally_clause",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "block",
          "named": true
        }
      ]
    }
  },
  {
    "type": "for_in_clause",
    "named": true,
    "fields": {
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "pattern",
            "named": true
          },
          {
            "type": "pattern_list",
            "named": true
          }
        ]
      },
      "right": {
        "multiple": true,
        "required": true,
        "types": [
          {
            "type": ",",
            "named": false
          },
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "for_statement",
    "named": true,
    "fields": {
      "alternative": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "else_clause",
            "named": true
          }
        ]
      },
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      },
      "left": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "pattern",
            "named": true
          },
          {
            "type": "pattern_list",
            "named": true
          }
        ]
      },
      "right": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          },
          {
            "type": "expression_list",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "format_expression",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "format_specifier",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "format_expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "function_definition",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      },
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "parameters": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "parameters",
            "named": true
          }
        ]
      },
      "return_type": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "type",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "future_import_statement",
    "named": true,
    "fields": {
      "name": {
        "multiple": true,
        "required": true,
        "types": [
          {
            "type": "aliased_import",
            "named": true
          },
          {
            "type": "dotted_name",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "generator_expression",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "for_in_clause",
          "named": true
        },
        {
          "type": "if_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "global_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "identifier",
          "named": true
        }
      ]
    }
  },
  {
    "type": "if_clause",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "if_statement",
    "named": true,
    "fields": {
      "alternative": {
        "multiple": true,
        "required": false,
        "types": [
          {
            "type": "elif_clause",
            "named": true
          },
          {
            "type": "else_clause",
            "named": true
          }
        ]
      },
      "condition": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "consequence": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "import_from_statement",
    "named": true,
    "fields": {
      "module_name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "dotted_name",
            "named": true
          },
          {
            "type": "relative_import",
            "named": true
          }
        ]
      },
      "name": {
        "multiple": true,
        "required": false,
        "types": [
          {
            "type": "aliased_import",
            "named": true
          },
          {
            "type": "dotted_name",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "wildcard_import",
          "named": true
        }
      ]
    }
  },
  {
    "type": "import_prefix",
    "named": true,
    "fields": {}
  },
  {
    "type": "import_statement",
    "named": true,
    "fields": {
      "name": {
        "multiple": true,
        "required": true,
        "types": [
          {
            "type": "aliased_import",
            "named": true
          },
          {
            "type": "dotted_name",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "interpolation",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "format_specifier",
          "named": true
        },
        {
          "type": "type_conversion",
          "named": true
        }
      ]
    }
  },
  {
    "type": "keyword_argument",
    "named": true,
    "fields": {
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "lambda",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "parameters": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "lambda_parameters",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "lambda_parameters",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "parameter",
          "named": true
        }
      ]
    }
  },
  {
    "type": "list",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_list_splat",
          "named": true
        },
        {
          "type": "yield",
          "named": true
        }
      ]
    }
  },
  {
    "type": "list_comprehension",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "for_in_clause",
          "named": true
        },
        {
          "type": "if_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "list_pattern",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "pattern",
          "named": true
        }
      ]
    }
  },
  {
    "type": "list_splat",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "list_splat_pattern",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "attribute",
          "named": true
        },
        {
          "type": "identifier",
          "named": true
        },
        {
          "type": "subscript",
          "named": true
        }
      ]
    }
  },
  {
    "type": "module",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "_compound_statement",
          "named": true
        },
        {
          "type": "_simple_statement",
          "named": true
        }
      ]
    }
  },
  {
    "type": "named_expression",
    "named": true,
    "fields": {
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "nonlocal_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "identifier",
          "named": true
        }
      ]
    }
  },
  {
    "type": "not_operator",
    "named": true,
    "fields": {
      "argument": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "pair",
    "named": true,
    "fields": {
      "key": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "parameters",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "parameter",
          "named": true
        }
      ]
    }
  },
  {
    "type": "parenthesized_expression",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_expression",
          "named": true
        },
        {
          "type": "yield",
          "named": true
        }
      ]
    }
  },
  {
    "type": "parenthesized_list_splat",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "pass_statement",
    "named": true,
    "fields": {}
  },
  {
    "type": "pattern_list",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "pattern",
          "named": true
        }
      ]
    }
  },
  {
    "type": "print_statement",
    "named": true,
    "fields": {
      "argument": {
        "multiple": true,
        "required": false,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "chevron",
          "named": true
        }
      ]
    }
  },
  {
    "type": "raise_statement",
    "named": true,
    "fields": {
      "cause": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "expression_list",
          "named": true
        }
      ]
    }
  },
  {
    "type": "relative_import",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "dotted_name",
          "named": true
        },
        {
          "type": "import_prefix",
          "named": true
        }
      ]
    }
  },
  {
    "type": "return_statement",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "expression_list",
          "named": true
        }
      ]
    }
  },
  {
    "type": "set",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_list_splat",
          "named": true
        },
        {
          "type": "yield",
          "named": true
        }
      ]
    }
  },
  {
    "type": "set_comprehension",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "for_in_clause",
          "named": true
        },
        {
          "type": "if_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "slice",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "string",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "escape_sequence",
          "named": true
        },
        {
          "type": "interpolation",
          "named": true
        }
      ]
    }
  },
  {
    "type": "subscript",
    "named": true,
    "fields": {
      "subscript": {
        "multiple": true,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          },
          {
            "type": "slice",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "try_statement",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "else_clause",
          "named": true
        },
        {
          "type": "except_clause",
          "named": true
        },
        {
          "type": "finally_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "tuple",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "list_splat",
          "named": true
        },
        {
          "type": "parenthesized_list_splat",
          "named": true
        },
        {
          "type": "yield",
          "named": true
        }
      ]
    }
  },
  {
    "type": "tuple_pattern",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": false,
      "types": [
        {
          "type": "pattern",
          "named": true
        }
      ]
    }
  },
  {
    "type": "type",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "expression",
          "named": true
        }
      ]
    }
  },
  {
    "type": "typed_default_parameter",
    "named": true,
    "fields": {
      "name": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "identifier",
            "named": true
          }
        ]
      },
      "type": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "type",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "typed_parameter",
    "named": true,
    "fields": {
      "type": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "type",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "dictionary_splat_pattern",
          "named": true
        },
        {
          "type": "identifier",
          "named": true
        },
        {
          "type": "list_splat_pattern",
          "named": true
        }
      ]
    }
  },
  {
    "type": "unary_operator",
    "named": true,
    "fields": {
      "argument": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "primary_expression",
            "named": true
          }
        ]
      },
      "operator": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "+",
            "named": false
          },
          {
            "type": "-",
            "named": false
          },
          {
            "type": "~",
            "named": false
          }
        ]
      }
    }
  },
  {
    "type": "while_statement",
    "named": true,
    "fields": {
      "alternative": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "else_clause",
            "named": true
          }
        ]
      },
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      },
      "condition": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "wildcard_import",
    "named": true,
    "fields": {}
  },
  {
    "type": "with_clause",
    "named": true,
    "fields": {},
    "children": {
      "multiple": true,
      "required": true,
      "types": [
        {
          "type": "with_item",
          "named": true
        }
      ]
    }
  },
  {
    "type": "with_item",
    "named": true,
    "fields": {
      "alias": {
        "multiple": false,
        "required": false,
        "types": [
          {
            "type": "pattern",
            "named": true
          }
        ]
      },
      "value": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      }
    }
  },
  {
    "type": "with_statement",
    "named": true,
    "fields": {
      "body": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "block",
            "named": true
          }
        ]
      }
    },
    "children": {
      "multiple": false,
      "required": true,
      "types": [
        {
          "type": "with_clause",
          "named": true
        }
      ]
    }
  },
  {
    "type": "yield",
    "named": true,
    "fields": {},
    "children": {
      "multiple": false,
      "required": false,
      "types": [
        {
          "type": "expression",
          "named": true
        },
        {
          "type": "expression_list",
          "named": true
        }
      ]
    }
  },
  {
    "type": "!=",
    "named": false
  },
  {
    "type": "\"",
    "named": false
  },
  {
    "type": "%",
    "named": false
  },
  {
    "type": "%=",
    "named": false
  },
  {
    "type": "&",
    "named": false
  },
  {
    "type": "&=",
    "named": false
  },
  {
    "type": "(",
    "named": false
  },
  {
    "type": ")",
    "named": false
  },
  {
    "type": "*",
    "named": false
  },
  {
    "type": "**",
    "named": false
  },
  {
    "type": "**=",
    "named": false
  },
  {
    "type": "*=",
    "named": false
  },
  {
    "type": "+",
    "named": false
  },
  {
    "type": "+=",
    "named": false
  },
  {
    "type": ",",
    "named": false
  },
  {
    "type": "-",
    "named": false
  },
  {
    "type": "-=",
    "named": false
  },
  {
    "type": "->",
    "named": false
  },
  {
    "type": ".",
    "named": false
  },
  {
    "type": "/",
    "named": false
  },
  {
    "type": "//",
    "named": false
  },
  {
    "type": "//=",
    "named": false
  },
  {
    "type": "/=",
    "named": false
  },
  {
    "type": ":",
    "named": false
  },
  {
    "type": ":=",
    "named": false
  },
  {
    "type": "<",
    "named": false
  },
  {
    "type": "<<",
    "named": false
  },
  {
    "type": "<<=",
    "named": false
  },
  {
    "type": "<=",
    "named": false
  },
  {
    "type": "<>",
    "named": false
  },
  {
    "type": "=",
    "named": false
  },
  {
    "type": "==",
    "named": false
  },
  {
    "type": ">",
    "named": false
  },
  {
    "type": ">=",
    "named": false
  },
  {
    "type": ">>",
    "named": false
  },
  {
    "type": ">>=",
    "named": false
  },
  {
    "type": "@",
    "named": false
  },
  {
    "type": "@=",
    "named": false
  },
  {
    "type": "[",
    "named": false
  },
  {
    "type": "]",
    "named": false
  },
  {
    "type": "^",
    "named": false
  },
  {
    "type": "^=",
    "named": false
  },
  {
    "type": "__future__",
    "named": false
  },
  {
    "type": "and",
    "named": false
  },
  {
    "type": "as",
    "named": false
  },
  {
    "type": "assert",
    "named": false
  },
  {
    "type": "async",
    "named": false
  },
  {
    "type": "await",
    "named": false
  },
  {
    "type": "break",
    "named": false
  },
  {
    "type": "class",
    "named": false
  },
  {
    "type": "comment",
    "named": true
  },
  {
    "type": "continue",
    "named": false
  },
  {
    "type": "def",
    "named": false
  },
  {
    "type": "del",
    "named": false
  },
  {
    "type": "elif",
    "named": false
  },
  {
    "type": "ellipsis",
    "named": true
  },
  {
    "type": "else",
    "named": false
  },
  {
    "type": "escape_sequence",
    "named": true
  },
  {
    "type": "except",
    "named": false
  },
  {
    "type": "exec",
    "named": false
  },
  {
    "type": "false",
    "named": true
  },
  {
    "type": "finally",
    "named": false
  },
  {
    "type": "float",
    "named": true
  },
  {
    "type": "for",
    "named": false
  },
  {
    "type": "from",
    "named": false
  },
  {
    "type": "global",
    "named": false
  },
  {
    "type": "identifier",
    "named": true
  },
  {
    "type": "if",
    "named": false
  },
  {
    "type": "import",
    "named": false
  },
  {
    "type": "in",
    "named": false
  },
  {
    "type": "integer",
    "named": true
  },
  {
    "type": "is",
    "named": false
  },
  {
    "type": "lambda",
    "named": false
  },
  {
    "type": "none",
    "named": true
  },
  {
    "type": "nonlocal",
    "named": false
  },
  {
    "type": "not",
    "named": false
  },
  {
    "type": "or",
    "named": false
  },
  {
    "type": "pass",
    "named": false
  },
  {
    "type": "print",
    "named": false
  },
  {
    "type": "raise",
    "named": false
  },
  {
    "type": "return",
    "named": false
  },
  {
    "type": "true",
    "named": true
  },
  {
    "type": "try",
    "named": false
  },
  {
    "type": "type_conversion",
    "named": true
  },
  {
    "type": "while",
    "named": false
  },
  {
    "type": "with",
    "named": false
  },
  {
    "type": "yield",
    "named": false
  },
  {
    "type": "{",
    "named": false
  },
  {
    "type": "|",
    "named": false
  },
  {
    "type": "|=",
    "named": false
  },
  {
    "type": "}",
    "named": false
  },
  {
    "type": "~",
    "named": false
  }
]') in: [:f |
		SBToggledCode
			comment: ''
			active: 0
			do: {[f grammar rules do: [:rule | f rule: 'parameters' inlineIn: rule]]}.
		SBToggledCode
			comment: ''
			active: 0
			do: {[f grammar at: 'inline' put: (f grammar inline copyWith: 'expression_statement')]}.
		f grammar blockInline: {'expression_statement'}.
		f cleanGrammar.
		f grammar rules keysAndValuesDo: [:name :r | f removeOptionalString: ',' in: r].
		f grammar rules
			at: '"'
			put: (JsonObject fromAssociations: {#type -> 'STRING'. #value -> '"'}).
		f statementContainerTypes: #('block').
		f]
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> textForNode: aNode [
	" TODO: will break with UTF-8 "

	^ currentString copyFrom: (self nodeStartByte: aNode) + 1 to: (self nodeEndByte: aNode)
]

{ #category : #'as yet unclassified' }
SBTreeSitter >> treeRootNode: aTree [

	<apicall: SBTSNode ts_tree_root_node (void*)>
	^ self externalCallFailed
]
