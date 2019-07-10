as yet unclassified
toggleRunning

	(self isSteppingSelector: #run)
		ifFalse: [self startRunning]
		ifTrue: [self stopRunning]