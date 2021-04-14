Class {
	#name : #SBBlockBodyTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBBlockBodyTest >> testInsertCommandRequest [

	| editor block |
	block := SBStBlockBody emptyWithDeclarations: {'a'. 'b'. 'c'}.
	editor := self methodFor: block.
	block statements: {SBStNumber new. SBStNumber new. SBStNumber new}.
	editor do: (block insertEmptyCommandRequestNear: block statements first before: false).
	self assert: block statements second isUnknown
]
