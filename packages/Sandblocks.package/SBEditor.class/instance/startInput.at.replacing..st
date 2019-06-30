input
startInput: aMorph at: aNumber replacing: aBoolean

	(aMorph startInputAt: aNumber replacingContents: aBoolean) ifNotNil: [:cmd |
		currentInput := aMorph.
		currentInputCommand := cmd.
		modeLabel contents: 'INSERT']