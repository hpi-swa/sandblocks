compilation cue protocol
receiver: anObject

	anObject ifNotNil: [self name: (anObject asString truncateWithElipsisTo: 20)].
	receiver := anObject