Class {
	#name : #SBBlockBodyTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBBlockBodyTest >> testInsertAfterTemporaries [

	| editor block |
	block := SBStBlockBody empty temporaries: {SBStName contents: 'a'}.
	editor := self methodFor: block.
	editor do: (block insertEmptyCommandRequestNear: block temporaries first before: false).
	self assert: block submorphs second isUnknown
]

{ #category : #'as yet unclassified' }
SBBlockBodyTest >> testInsertCommandRequest [

	| editor block |
	block := SBStBlockBody emptyWithDeclarations: {'a'. 'b'. 'c'}.
	editor := self methodFor: block.
	block statements: {SBStNumber new. SBStNumber new. SBStNumber new}.
	editor do: (block insertEmptyCommandRequestNear: block statements first before: false).
	self assert: block statements second isUnknown
]
