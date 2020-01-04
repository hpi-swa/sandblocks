as yet unclassified
sendStartNotification

	self sandblockEditor allBlocksDo: [:morph |
		morph isExampleWatch ifTrue: [morph exampleStarting: self]]