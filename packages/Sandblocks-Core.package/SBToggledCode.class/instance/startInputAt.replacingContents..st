as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	comment owner ifNil: [self addMorphFront: comment].
	
	self sandblockEditor replaceInput: comment.
	^ comment startInputAt: aNumber replacingContents: aBoolean