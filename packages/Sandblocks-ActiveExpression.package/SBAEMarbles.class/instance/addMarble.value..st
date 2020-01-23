as yet unclassified
addMarble: aMorph value: anObject

	self updateTickDividers.
	self addMorphBack: (SBMarble new subject: aMorph value: anObject)