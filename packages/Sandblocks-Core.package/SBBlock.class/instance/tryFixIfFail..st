as yet unclassified
tryFixIfFail: aBlock

	self sandblockEditor select: self.
	self fixActions
		ifNotEmpty: [:actions | self proposeCodeActions: actions for: self].
	^ self valid ifTrue: [true] ifFalse: aBlock