Class {
	#name : #SBASTNodeTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testBindingRename [

	| block editor |
	block := '[|from to| from squared. from squared]' parseAsSandblock.
	editor := self methodFor: block.
	
	editor startInput: block statements last receiver at: 1 replacingContents: true.
	block statements last receiver keyStroke: (self keyboardEvent: $t).
	block statements last receiver keyStroke: (self keyboardEvent: $o).
	editor performAction: #moveCursorUp.
	self assert: 'from' equals: block statements first receiver contents.
	self assert: 'to' equals: block statements last receiver contents
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testCanClearMessagePart [

	| block selection editor |
	block := '[a + 5]' parseAsSandblock.
	selection := block statements first messageParts first.
	editor := (self methodFor: block) select: selection.
	editor startInput: selection at: 1 replacingContents: true.
	editor endInput.
	self assert: ':' equals: selection contents.
	self assert: selection parentSandblock isMessageSend
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testCanUndoAppendLine [

	| block selection editor |
	block := '[5]' parseAsSandblock.
	editor := self methodFor: block.
	selection := block statements first.
	selection performAction: #insertStatementBelow.
	
	block statements last keyStroke: (self keyboardEvent: $s).
	editor endInput.
	self assert: 2 equals: (editor history instVarNamed: #undoStack) size.
	
	editor undo.
	
	self assert: 1 equals: block statements size
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testChangeSendToAssignment [

	| block selection editor |
	block := '[a + 5]' parseAsSandblock.
	selection := block statements first messageParts first.
	editor := (self methodFor: block) select: selection.
	editor startInput: selection at: 1 replacingContents: true.
	selection keyStroke: (self keyboardEvent: $:).
	self assert: block statements first isAssignment.
	self assert: block statements first contents = ':='.
	self assert: block statements first isMessageSend not
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testInsertStatementAboveOrBelow [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self methodFor: block.
	selection performAction: #insertStatementBelow.
	self assert: block statements last isUnknown.
	selection performAction: #insertStatementAbove.
	self assert: block statements first isUnknown
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testMergeMessages [

	| block editor |
	block := '[self assert: (5 equals: 3)]' parseAsSandblock.
	editor := self methodFor: block.
	
	block statements first arguments first performAction: #unwrapList.
	self assert: #assert:equals: equals: block statements first selector
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testUndoChangeSendToAssignment [

	| block selection editor |
	block := '[a + 5]' parseAsSandblock.
	selection := block statements first messageParts first.
	editor := (self methodFor: block) select: selection.
	editor startInput: selection at: 1 replacingContents: true.
	selection keyStroke: (self keyboardEvent: $:).
	editor undo.
	editor redo.
	self assert: block statements first isAssignment.
	self assert: block statements first messageParts first currentTextMorph contents = ':'.
	self assert: block statements first contents = ':='.
	self assert: block statements first isMessageSend not
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testUndoWrapInArray [

	| block selection editor |
	block := '[self squared. self changeTableLayout. self resize]' parseAsSandblock.
	selection := block statements first.
	editor := self methodFor: block.
	editor select: selection.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	editor startOrAddToMultiSelection: block statements third.
	selection performAction: #wrapInDynamicArray.
	self assert: block statements first isArrayBlock.
	self assert: block statements first submorphs first = selection.
	self assert: block statements first submorphs second selector = 'changeTableLayout'.
	self assert: block statements first submorphs third selector = 'resize'.
	editor undo.
	self assert: block statements first selector = 'squared'.
	self assert: block statements second selector = 'changeTableLayout'.
	self assert: block statements third selector = 'resize'.
	self assert: block statements third receiver contents = 'self'
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testUndoWrapInBlock [

	| block selection editor |
	block := '[self squared. self changeTableLayout. self resize]' parseAsSandblock.
	selection := block statements first.
	editor := self methodFor: block.
	editor select: selection.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	editor startOrAddToMultiSelection: block statements third.
	selection performAction: #wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection.
	self assert: block statements first statements second selector = 'changeTableLayout'.
	self assert: block statements first statements third selector = 'resize'.
	editor undo.
	self assert: block statements first selector = 'squared'.
	self assert: block statements second selector = 'changeTableLayout'.
	self assert: block statements third selector = 'resize'.
	self assert: block statements third receiver contents = 'self'
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testUndoWrapInCascade [

	| block selection editor |
	block := '[self squared. self changeTableLayout. self resize]' parseAsSandblock.
	selection := block statements first.
	editor := self methodFor: block.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	editor startOrAddToMultiSelection: block statements third.
	editor select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection.
	editor undo.
	self assert: block statements first selector = 'squared'.
	self assert: block statements second selector = 'changeTableLayout'.
	self assert: block statements third selector = 'resize'.
	self assert: block statements third receiver contents = 'self'
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapAsArgument [

	| block selection |
	block := '[5]' parseAsSandblock.
	self methodFor: block.
	selection := block statements first.
	selection performAction: #wrapAsArgument.
	self assert: block statements first isMessageSend.
	self assert: block statements first arguments first = selection.
	self assert: block statements first receiver isUnknown
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInArrayType [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection performAction: #wrapInDynamicArray.
	self assert: block statements first isArrayBlock.
	self assert: block statements first firstSubmorph = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInBlock [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection performAction: #wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascade [

	| block selection |
	block := '[5 squared]' parseAsSandblock.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascadeMessageParts [

	| block selection editor |
	block := '[5 yourself. 5 parse: 2]' parseAsSandblock.
	selection := block statements first.
	editor := self methodFor: block.
	editor select: selection.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second messageParts first.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection.
	self assert: block statements first messages first receiver isNil.
	self assert: block statements first messages second receiver isNil
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInCascadeMultiSelection [

	| block selection editor |
	block := '[5 squared. 5 + 2]' parseAsSandblock.
	selection := block statements first.
	editor := self methodFor: block.
	editor select: selection.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection.
	self assert: block statements first messages first receiver isNil.
	self assert: block statements first messages second receiver isNil
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInMessageSend [

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self methodFor: block.
	selection grammarHandler
		block: selection;
		wrapInMessageSend: 'hello'.
	self assert: block statements first isMessageSend.
	self assert: block statements first selector = 'hello'.
	self assert: block statements first receiver = selection
]

{ #category : #'as yet unclassified' }
SBASTNodeTest >> testWrapInReturn [

	| block selection |
	block := '[5]' parseAsSandblock.
	self methodFor: block.
	selection := block statements first.
	selection performAction: #wrapInReturn.
	self assert: block statements first isReturn.
	self assert: block statements first expression = selection
]
