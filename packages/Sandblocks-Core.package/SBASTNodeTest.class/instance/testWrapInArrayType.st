as yet unclassified
testWrapInArrayType

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: selection.
	selection wrapInArrayType: #dynamic.
	self assert: block statements first isArrayBlock.
	self assert: block statements first firstSubmorph = selection