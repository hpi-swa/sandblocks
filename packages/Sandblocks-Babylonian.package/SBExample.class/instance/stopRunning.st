as yet unclassified
stopRunning

	self stopSteppingSelector: #run.
	active := false.
	returnValue clear.
	self updateIcon.
	
	self sandblockEditor allMorphsDo: [:morph |
		(morph isSandblock and: [morph listensToExamples]) ifTrue: [morph exampleStopped: self]]