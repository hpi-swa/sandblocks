as yet unclassified
matches: anObject

	^ (super matches: anObject) and: [anObject isMessageSend]