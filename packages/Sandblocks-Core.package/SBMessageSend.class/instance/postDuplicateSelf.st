as yet unclassified
postDuplicateSelf

	self isInCascade ifTrue: [self receiver: nil].
	super postDuplicateSelf