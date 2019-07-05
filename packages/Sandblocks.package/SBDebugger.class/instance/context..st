as yet unclassified
context: aContext

	aContext method ~= (context ifNotNil: #method) ifTrue: [
		editor compiledMethod: aContext method.
		self flag: #fixme. "ideally we do not want to reset here, but then we have to cache the compiled methods of our stack so the morph identity stays the same"
		blockValues := Dictionary new].
	context := aContext.
	
	self currentBlockForPC ifNotNil: [:block | editor select: block].
	pcLabel contents: context pc asString.
	
	currentStack := aContext contextStack.
	frames labels: (currentStack collect: [:ctx | ctx printString]).
	frames selectionIndex: 1