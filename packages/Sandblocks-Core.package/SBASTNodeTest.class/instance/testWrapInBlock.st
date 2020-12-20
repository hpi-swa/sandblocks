as yet unclassified
testWrapInBlock

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: selection.
	selection wrapInBlock.
	self assert: block statements first isBlockBody.
	self assert: block statements first statements first = selection