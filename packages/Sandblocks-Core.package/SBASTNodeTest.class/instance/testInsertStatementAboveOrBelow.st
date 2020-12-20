as yet unclassified
testInsertStatementAboveOrBelow

	| block selection |
	block := '[5]' parseAsSandblock.
	selection := block statements first.
	self editorFor: block.
	selection insertStatementBelow.
	self assert: block statements last isUnknown.
	selection insertStatementAbove.
	self assert: block statements first isUnknown