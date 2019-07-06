as yet unclassified
setBinaryMessage: aString

	currentInputMessagePart contents: aString.
	self flag: #fixme. " gonna be very annoying typing <= "
	self addArgumentAndEditAfter: currentInputMessagePart focusKeyword: currentInputMessagePart