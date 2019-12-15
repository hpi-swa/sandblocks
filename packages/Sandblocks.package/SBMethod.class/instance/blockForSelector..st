as yet unclassified
blockForSelector: aSymbol

	self allBlocksDo: [:block |
		(block isMessageSend and: [block selector = aSymbol]) ifTrue: [^ block]].
	^ nil