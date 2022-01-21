Class {
	#name : #SBInputDeleteTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testDeleteInArray [

	| block editor array |
	block := self parse: '[{a. b}]'.
	editor := self methodFor: block.
	
	array := block statements first.
	editor startInput: array childSandblocks first at: 2 replacingContents: false.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: 1 equals: array childSandblocks size.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: 0 equals: array childSandblocks size
]

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testDeleteInBinaryExpression [

	| block editor b |
	block := self parse: '[a + b]'.
	editor := self methodFor: block.
	
	b := block statements first arguments first.
	editor startInput: b at: 3 replacingContents: false.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: '[(a + ).\]' withCRs equals: block sourceString.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: '[(a : ).\]' withCRs equals: block sourceString.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: '[a.\]' withCRs equals: block sourceString
]

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testDeleteInBlock [

	| a block editor |
	block := self parse: '[[a]]'.
	editor := self methodFor: block.
	a := block statements first statements first.
	
	editor startInput: a at: 3 replacingContents: false.
	
	a deleteBeforeCursor.
	block statements first statements first deleteBeforeCursor.
	
	self assert: block statements first isUnknown.
	self assert: editor mode = #input
]

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testDeleteInEmptyString [

	| block editor string |
	string := SBStString new contents: ''.
	block := self parse: '[]'.
	editor := self methodFor: block.
	block addMorphBack: string.
	editor startInput: string at: 0 replacingContents: false.
	editor performForSelection: #deleteBeforeCursor.
	self assert: block statements notEmpty.
	editor performForSelection: #deleteBeforeCursor.
	self assert: block statements isEmpty
]

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testDeleteInNestedArray [

	| block editor a |
	block := self parse: '[self square: {a}]'.
	editor := self methodFor: block.
	
	a := block statements first arguments first submorphs first.
	editor startInput: a at: 3 replacingContents: false.
	
	editor performForSelection: #deleteBeforeCursor.
	self assert: '[(self square: {}).\]' withCRs equals: block sourceString.
	
	editor performForSelection: #deleteBeforeCursor.
	editor performForSelection: #deleteBeforeCursor.
	self assert: '[(self square).\]' withCRs equals: block sourceString
]

{ #category : #'as yet unclassified' }
SBInputDeleteTest >> testNestedSends [

	| block |
	block := self parse: '[a squared s]'.
	self editorFor: block.
	
	block statements first messageParts first
		select;
		startInputAtEnd.
	block statements first messageParts first performAction: #deleteBeforeCursor.
	block statements first messageParts first performAction: #deleteBeforeCursor.
	block statements first messageParts first performAction: #deleteBeforeCursor.
	self assert: 'square' equals: block statements first messageParts first contents
]
