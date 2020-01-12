as yet unclassified
tryFixIfFail: aBlock

	self fixActions
		ifEmpty: [self sandblockEditor select: self]
		ifNotEmpty: [:actions | self proposeCodeActions: actions for: self].
	^ self valid ifTrue: [true] ifFalse: aBlock