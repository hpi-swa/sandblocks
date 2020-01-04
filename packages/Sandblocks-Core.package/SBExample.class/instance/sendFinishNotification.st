as yet unclassified
sendFinishNotification

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleFinished: self]]