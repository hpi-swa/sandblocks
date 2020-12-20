as yet unclassified
testSwap

	| block selection n5 n3 |
	block := '[5 squared: 3]' parseAsSandblock.
	self editorFor: block.
	selection := block statements first.
	n5 := selection receiver.
	n3 := selection arguments first.
	n5 swapRight.
	self assert: selection receiver = n3.
	n5 swapRight.
	self assert: selection receiver = n5.
	n5 swapLeft.
	self assert: selection receiver = n3