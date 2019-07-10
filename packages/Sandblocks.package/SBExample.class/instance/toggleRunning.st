as yet unclassified
toggleRunning

	(self isSteppingSelector: #run)
		ifFalse: [self startSteppingSelector: #run]
		ifTrue: [self stopSteppingSelector: #run].
	self updateIcon