Class {
	#name : #SBMetaBlockFactoryTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest >> factory [

	^ SBMetaBlockFactory new
		grammar: '{
  "name": "small",
  "rules": {
    "source_file": {
      "type": "REPEAT",
      "content": {
        "type": "SYMBOL",
        "name": "expression"
      }
    },
    "expression": {
      "type": "CHOICE",
      "members": [
        {
          "type": "SYMBOL",
          "name": "number"
        },
        {
          "type": "SYMBOL",
          "name": "binary_op"
        },
        {
          "type": "SYMBOL",
          "name": "unary_op"
        }
      ]
    },
    "binary_op": {
      "type": "PREC_LEFT",
      "value": 2,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "FIELD",
            "name": "lhs",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          },
          {
            "type": "FIELD",
            "name": "op",
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
                  "value": "*"
                }
              ]
            }
          },
          {
            "type": "FIELD",
            "name": "rhs",
            "content": {
              "type": "SYMBOL",
              "name": "expression"
            }
          }
        ]
      }
    },
    "unary_op": {
      "type": "PREC",
      "value": 5,
      "content": {
        "type": "SEQ",
        "members": [
          {
            "type": "STRING",
            "value": "-"
          },
          {
            "type": "SYMBOL",
            "name": "expression"
          }
        ]
      }
    },
    "number": {
      "type": "PATTERN",
      "value": "\\d+"
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
    "expression"
  ]
}

'
		nodeTypes: '[
  {
    "type": "expression",
    "named": true,
    "subtypes": [
      {
        "type": "binary_op",
        "named": true
      },
      {
        "type": "number",
        "named": true
      },
      {
        "type": "unary_op",
        "named": true
      }
    ]
  },
  {
    "type": "binary_op",
    "named": true,
    "fields": {
      "lhs": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "expression",
            "named": true
          }
        ]
      },
      "op": {
        "multiple": false,
        "required": true,
        "types": [
          {
            "type": "*",
            "named": false
          },
          {
            "type": "+",
            "named": false
          },
          {
            "type": "-",
            "named": false
          }
        ]
      },
      "rhs": {
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
    "type": "source_file",
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
    "type": "unary_op",
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
    "type": "*",
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
    "type": "number",
    "named": true
  }
]'
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest >> testUnambiguousRuleBinaryOp [

	| source editor |
	source := self factory buildRule: 'source_file'.
	editor := self editorFor: source.
	
	source appendElement.
	editor selection keyStroke: (self keyboardEvent: '4').
	
	self assert: #('number') equals: source childSandblocks first objectInterfaces
]
