as yet unclassified
sendStartNotification

	self containingMethod allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleStarting: self]]