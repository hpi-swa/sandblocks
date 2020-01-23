as yet unclassified
addMarble: aMorph value: anObject sideEffects: aCollection

	self updateTickDividers.
	self addMorphBack: (SBMarble new subject: aMorph; value: anObject; sideEffects: aCollection)