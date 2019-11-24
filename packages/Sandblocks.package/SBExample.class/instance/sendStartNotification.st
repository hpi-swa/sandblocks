as yet unclassified
sendStartNotification

	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleStarting: self]]