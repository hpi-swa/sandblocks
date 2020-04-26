as yet unclassified
on: anObject

	self removeAllMorphs.
	
	inspector := anObject inspectorClass on: anObject.
	object := anObject.
	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBIcon iconBars
			on: #startDrag send: #pickUp: to: self;
			yourself);
		addMorphBack: (label := SBStringMorph new contents: (anObject asString truncateWithElipsisTo: 40)))