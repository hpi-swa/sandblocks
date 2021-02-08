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
	editor do: (block insertCommandRequest: true near: block statements first).
	self assert: block statements second isUnknown
]
