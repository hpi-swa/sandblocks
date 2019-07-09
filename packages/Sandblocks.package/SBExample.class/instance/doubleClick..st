as yet unclassified
doubleClick: anEvent

	(self isSteppingSelector: #run)
		ifFalse: [self startSteppingSelector: #run]
		ifTrue: [self stopSteppingSelector: #run].
	self updateIcon