as yet unclassified
matches: aMessageSend

	^ aMessageSend isSandblock and: [aMessageSend isMessageSend or: [self matchesCascades and: [aMessageSend isCascade]]]