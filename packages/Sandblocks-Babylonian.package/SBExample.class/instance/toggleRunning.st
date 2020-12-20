as yet unclassified
toggleRunning
	<action>

	self active
		ifFalse: [self startRunning]
		ifTrue: [self stopRunning]