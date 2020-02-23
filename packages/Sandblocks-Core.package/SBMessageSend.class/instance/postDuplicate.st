as yet unclassified
postDuplicate

	self isInCascade ifTrue: [self receiver: nil].
	self updateInsets.
	super postDuplicate