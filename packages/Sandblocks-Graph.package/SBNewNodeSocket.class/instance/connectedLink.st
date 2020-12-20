as yet unclassified
connectedLink

	self assert: self connectedLinks size <= 1.
	^ self connectedLinks ifEmpty: [nil] ifNotEmpty: #first