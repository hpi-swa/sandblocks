as yet unclassified
noteNewOwner: aMorph

	super noteNewOwner: aMorph.
	
	self isInCascade ifTrue: [self receiver: nil]