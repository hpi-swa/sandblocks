as yet unclassified
testWrapInCascade

	| block selection |
	block := '[5 squared]' parseAsSandblock.
	selection := block statements first.
	(self editorFor: block) select: selection.
	selection wrapInCascade.
	self assert: block statements first isCascade.
	self assert: block statements first messages first = selection