as yet unclassified
nextOnMessage: next with: aBlock

	^ next isMessageSend
		ifTrue: [next firstDeepChild]
		ifFalse: [
			(next parentSandblock isMessageSend and: [aBlock isLastChild]) ifTrue: [aBlock parentSandblock] ifFalse: [next]]