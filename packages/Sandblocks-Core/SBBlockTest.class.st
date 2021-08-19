Class {
	#name : #SBBlockTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBBlockTest >> testLeftRotateBinaryMessages [

	| block selection editor |
	block := '[(a + b) * c]' parseAsSandblock.
	editor := self methodFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: block statements first selector = '+'.
	self assert: block statements first receiver contents = 'a'.
	editor undo.
	self assert: block statements first selector = '*'.
	self assert: block statements first receiver receiver contents = 'a'
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testRotateBlock [

	| block selection editor |
	block := '[a or: [b]]' parseAsSandblock.
	editor := self methodFor: block.
	selection := block statements first arguments first.
	selection leftRotate.
	self assert: block statements first isBlockBody.
	self assert: 'or:' equals: block statements first statements first selector.
	editor undo.
	self assert: 'or:' equals: block statements first selector.
	self assert: block statements first arguments first isBlockBody
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testRotateKeywordMessage [

	| block selection editor |
	block := '[(a or: b) ifTrue: c]' parseAsSandblock.
	editor := self methodFor: block.
	selection := block statements first receiver.
	selection leftRotate.
	self assert: 'or:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver contents.
	editor undo.
	self assert: 'ifTrue:' equals: block statements first selector.
	self assert: 'a' equals: block statements first receiver receiver contents
]

{ #category : #'as yet unclassified' }
SBBlockTest >> testSwap [

	| block selection n5 n3 |
	block := '[5 squared: 3]' parseAsSandblock.
	self methodFor: block.
	selection := block statements first.
	n5 := selection receiver.
	n3 := selection arguments first.
	n5 swapRight.
	self assert: selection receiver = n3.
	n5 swapRight.
	self assert: selection receiver = n5.
	n5 swapLeft.
	self assert: selection receiver = n3
]
