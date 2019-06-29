as yet unclassified
startInput: aMorph at: aNumber replacing: aBoolean

	(aMorph startInputAt: aNumber replacingContents: aBoolean) ifNotNil: [:cmd |
		currentInput := aMorph.
		currentInputCommand := cmd]