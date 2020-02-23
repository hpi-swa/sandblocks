as yet unclassified
setBinaryMessage: aString

	currentInputMessagePart contents: aString.
	self flag: #fixme. " gonna be very annoying typing <= "
	
	self submorphCount = 1
		ifTrue: [self addArgumentAndEditAfter: currentInputMessagePart focusKeyword: currentInputMessagePart]
		ifFalse: [self moveCursorTo: 9e8]