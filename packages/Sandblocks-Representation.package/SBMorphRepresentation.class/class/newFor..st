as yet unclassified
newFor: anObject

	^ SBMorphWrapperBlock new
		addMorphLater: anObject;
		yourself