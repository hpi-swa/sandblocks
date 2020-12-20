as yet unclassified
matches: aMessageSend

	(super matches: aMessageSend) ifFalse: [^ false].
	^ self selector: 'do:identifier:' receiverMatches: aMessageSend