as yet unclassified
testWrapInReturn

	| block selection |
	block := '[5]' parseAsSandblock.
	self editorFor: block.
	selection := block statements first.
	selection wrapInReturn.
	self assert: block statements first isReturn.
	self assert: block statements first expression = selection