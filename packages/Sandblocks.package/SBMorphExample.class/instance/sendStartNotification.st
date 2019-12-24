as yet unclassified
sendStartNotification

	self sandblockEditor allBlocksDo: [:morph |
		morph isGlobalWatch ifTrue: [morph exampleStarting: self]]