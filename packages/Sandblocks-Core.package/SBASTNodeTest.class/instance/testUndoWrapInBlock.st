as yet unclassified
testUndoWrapInBlock

	| block selection editor |
	block := '[self squared. self changeTableLayout. self resize]' parseAsSandblock.
	selection := block statements first.
	editor := self editorFor: block.
	editor startOrAddToMultiSelection: block statements first.
	editor startOrAddToMultiSelection: block statements second.
	editor startOrAddToMultiSelection: block statements third.
	editor select: selection.
	selection wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection.
	self assert: block statements first statements second selector = 'changeTableLayout'.
	self assert: block statements first statements third selector = 'resize'.
	editor undo.
	self assert: block statements first selector = 'squared'.
	self assert: block statements second selector = 'changeTableLayout'.
	self assert: block statements third selector = 'resize'.
	self assert: block statements third receiver contents = 'self'