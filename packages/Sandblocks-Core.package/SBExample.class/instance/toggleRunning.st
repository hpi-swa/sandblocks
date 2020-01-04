as yet unclassified
toggleRunning

	self active
		ifFalse: [self startRunning]
		ifTrue: [self stopRunning]