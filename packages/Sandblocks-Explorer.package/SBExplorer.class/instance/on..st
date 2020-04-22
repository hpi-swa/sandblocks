as yet unclassified
on: anObject

	inspector := anObject inspectorClass on: anObject.
	object := anObject.
	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBIcon iconBars
			on: #startDrag send: #pickUp: to: self;
			yourself);
		addMorphBack: (SBStringMorph new contents: (anObject printStringLimitedTo: 40)))