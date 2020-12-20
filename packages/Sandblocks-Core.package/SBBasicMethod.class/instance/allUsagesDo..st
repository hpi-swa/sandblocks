as yet unclassified
allUsagesDo: aBlock

	^ self sandblockEditor allBlocksDo: [:block |
		(block isMessageSend and: [
			block selector = self selector and: [
				block receiver guessClassExpensive = self methodClass]]) ifTrue: [aBlock value: block]]