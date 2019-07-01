input
startInput: aMorph at: aNumber replacingContents: aBoolean

	" needs to be set first, as startInputAt: may choose to immediately replace this "
	self select: aMorph.
	currentInput := aMorph.
	(aMorph startInputAt: aNumber replacingContents: aBoolean)
		ifNotNil: [:cmd |
			currentInputCommand := cmd.
			modeLabel contents: 'INSERT']
		ifNil: [currentInput := nil]