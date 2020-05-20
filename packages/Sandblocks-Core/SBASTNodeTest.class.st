Class {
	#name : #SBASTNodeTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testInsertStatementAboveOrBelow [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self editorFor: block.
	selection insertStatementBelow.
	self assert: block statements last isUnknown.
	selection insertStatementAbove.
	self assert: block statements first isUnknown
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapAsArgument [

	| block selection |
	block := '[5]' parseAsSandblock.
	self editorFor: block.
	selection := block statements first.
	selection wrapAsArgument.
	self assert: block statements first isMessageSend.
	self assert: block statements first arguments first = selection.
	self assert: block statements first receiver isUnknown
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInArrayType [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: block.
	selection wrapInArrayType: #dynamic.
	self assert: block statements first isArrayBlock.
	self assert: block statements first firstSubmorph = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInBlock [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: selection.
	selection wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascade [

	| block selection |
	block := '[5 squared]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascadeMultiSelection [

	| block selection editor |
	block := '[5 squared. 5 + 2]' parseAsSandblock.
	selection := block statements first.
	editor := self editorFor: block.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	editor select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascadeNoMessageSend [

	| block selection editor |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	editor := self editorFor: block.
	editor select: selection.
	selection wrapInCascade.
	self assert: block statements first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInMessageSend [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self editorFor: block.
	selection wrapInMessageSend: 'hello'.
	self assert: block statements first isMessageSend.
	self assert: block statements first selector = 'hello'.
	self assert: block statements first receiver = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInReturn [

	| block selection |
	block := '[5]' parseAsSandblock.
	self editorFor: block.
	selection := block statements first.
	selection wrapInReturn.
	self assert: block statements first isReturn.
	self assert: block statements first expression = selection
]
