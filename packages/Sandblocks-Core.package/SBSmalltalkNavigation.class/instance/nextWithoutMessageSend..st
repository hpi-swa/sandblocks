as yet unclassified
nextWithoutMessageSend: aBlock

	^ aBlock isMessageSend
		ifTrue: [
			aBlock isInCascade
				ifTrue: [aBlock messageParts first]
			ifFalse: [self nextWithoutMessageSend: aBlock receiver]]
		ifFalse: [aBlock]