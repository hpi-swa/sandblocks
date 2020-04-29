as yet unclassified
stopRunning

	self stopSteppingSelector: #run.
	active := false.
	returnValue contents: ''.
	self updateIcon.
	
	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph isExampleWatch]) ifTrue: [morph exampleStopped: self]]