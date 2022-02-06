Class {
	#name : #SBASTNodeTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #tests }
SBASTNodeTest >> testBindingRename [

	| block editor |
	block := self parse: '[|from to| from squared. from squared]'.
	editor := self methodFor: block.
	
	editor startInput: block statements last receiver at: 1 replacingContents: true.
	block statements last receiver keyStroke: (self keyboardEvent: $t).
	block statements last receiver keyStroke: (self keyboardEvent: $o).
	editor performAction: #moveCursorUp.
	self assert: 'from' equals: block statements first receiver contents.
	self assert: 'to' equals: block statements last receiver contents
]

{ #category : #tests }
SBASTNodeTest >> testCanClearMessagePart [

	| block selection editor |
	block := self parse: '[a + 5]'.
	selection := block statements first messageParts first.
	editor := (self methodFor: block) select: selection.
	editor startInput: selection at: 1 replacingContents: true.
	editor endInput.
	self assert: ':' equals: selection contents.
	self assert: selection parentSandblock isMessageSend
]

{ #category : #tests }
SBASTNodeTest >> testCanUndoAppendLine [

	| block selection editor |
	block := self parse: '[5]'.
	editor := self methodFor: block.
	selection := block statements first.
	selection performAction: #insertStatementBelow.
	
	block statements last keyStroke: (self keyboardEvent: $s).
	editor endInput.
	self assert: 2 equals: (editor history instVarNamed: #undoStack) size.
	
	editor undo.
	
	self assert: 1 equals: block statements size
]

{ #category : #tests }
SBASTNodeTest >> testChangeSendToAssignment [

	| block selection editor |
	block := self parse: '[a + 5]'.
	selection := block statements first messageParts first.
	editor := (self methodFor: block) select: selection.
	editor startInput: selection at: 1 replacingContents: true.
	selection keyStroke: (self keyboardEvent: $:).
	self assert: block statements first isAssignment.
	self assert: block statements first contents = ':='.
	self assert: block statements first isMessageSend not
]

{ #category : #tests }
SBASTNodeTest >> testInsertStatementAboveOrBelow [

	| block selection |
	block := self parse: '[5]'.
	selection := block statements first.
	self methodFor: block.
	selection performAction: #insertStatementBelow.
	self assert: block statements last isUnknown.
	selection performAction: #insertStatementAbove.
	self assert: block statements first isUnknown
]

{ #category : #tests }
SBASTNodeTest >> testMergeMessages [

	| block editor |
	block := self parse: '[self assert: (5 equals: 3)]'.
	editor := self methodFor: block.
	
	block statements first arguments first performAction: #unwrapList.
	self assert: #assert:equals: equals: block statements first selector
]

{ #category : #tests }
SBASTNodeTest >> testUndoChangeSendToAssignment [

	| block selection editor |
	block := self parse: '[a + 5]'.
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

{ #category : #tests }
SBASTNodeTest >> testUndoWrapInArray [

	| block selection editor |
	block := self parse: '[self squared. self changeTableLayout. self resize]'.
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

{ #category : #tests }
SBASTNodeTest >> testUndoWrapInBlock [

	| block selection editor |
	block := self parse: '[self squared. self changeTableLayout. self resize]'.
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

{ #category : #tests }
SBASTNodeTest >> testUndoWrapInCascade [

	| block selection editor |
	block := self parse: '[self squared. self changeTableLayout. self resize]'.
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

{ #category : #tests }
SBASTNodeTest >> testWrapAsArgument [

	| block selection |
	block := self parse: '[5]'.
	self methodFor: block.
	selection := block statements first.
	selection performAction: #wrapAsArgument.
	self assert: block statements first isMessageSend.
	self assert: block statements first arguments first = selection.
	self assert: block statements first receiver isUnknown
]

{ #category : #tests }
SBASTNodeTest >> testWrapInArrayType [

	| block selection |
	block := self parse: '[5]'.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection performAction: #wrapInDynamicArray.
	self assert: block statements first isArrayBlock.
	self assert: block statements first firstSubmorph = selection
]

{ #category : #tests }
SBASTNodeTest >> testWrapInBlock [

	| block selection |
	block := self parse: '[5]'.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection performAction: #wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection
]

{ #category : #tests }
SBASTNodeTest >> testWrapInCascade [

	| block selection |
	block := self parse: '[5 squared]'.
	selection := block statements first.
	(self methodFor: block) select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection
]

{ #category : #tests }
SBASTNodeTest >> testWrapInCascadeMessageParts [

	| block selection editor |
	block := self parse: '[5 yourself. 5 parse: 2]'.
	selection := block statements first.
	editor := self methodFor: block.
	editor select: selection.
	block statements first startOrAddToMultiSelection.
	block statements second messageParts first startOrAddToMultiSelection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection.
	self assert: block statements first messages first receiver isNil.
	self assert: block statements first messages second receiver isNil
]

{ #category : #tests }
SBASTNodeTest >> testWrapInCascadeMultiSelection [

	| block selection editor |
	block := self parse: '[5 squared. 5 + 2]'.
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

{ #category : #tests }
SBASTNodeTest >> testWrapInMessageSend [

	| block selection |
	block := self parse: '[5]'.
	selection := block statements first.
	self methodFor: block.
	selection grammarHandler
		block: selection;
		wrapInMessageSend: 'hello'.
	self assert: block statements first isMessageSend.
	self assert: block statements first selector = 'hello'.
	self assert: block statements first receiver = selection
]

{ #category : #tests }
SBASTNodeTest >> testWrapInReturn [

	| block selection |
	block := self parse: '[5]'.
	self methodFor: block.
	selection := block statements first.
	selection performAction: #wrapInReturn.
	self assert: block statements first isReturn.
	self assert: block statements first expression = selection
]
