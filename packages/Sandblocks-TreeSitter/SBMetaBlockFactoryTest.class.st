Class {
	#name : #SBMetaBlockFactoryTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-TreeSitter-Tests'
}

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest class >> factory [

	^ SBMetaBlockFactory new grammar: '{
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
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest >> factory [

	^ self class factory
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest >> testConvertToBinaryOp [

	| source editor |
	source := self factory build: 'source_file'.
	editor := self editorFor: source.
	source appendElement.
	editor selection keyStroke: (self keyboardEvent: '4').
	editor selection keyStroke: (self keyboardEvent: '+').
	
	self assert: 'binary_op' equals: source childSandblocks first objectInterface.
	self assert: '+' equals: (SBExampleWatch report: source childSandblocks first contents for: 68009758)
]

{ #category : #'as yet unclassified' }
SBMetaBlockFactoryTest >> testUnambiguousRuleBinaryOp [

	| source editor |
	source := self factory build: 'source_file'.
	editor := self editorFor: source.
	
	source appendElement.
	editor selection keyStroke: (self keyboardEvent: '4').
	
	self assert: 'number' equals: source childSandblocks first objectInterface
]
