as yet unclassified
startInputAt: aNumber replacingContents: aBoolean

	self sandblockEditor replaceInput: self firstSubmorph.
	^ self firstSubmorph startInputAt: aNumber replacingContents: aBoolean