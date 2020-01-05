as yet unclassified
addRow: aLabelString with: aBlock

	self addMorphBack: (SBRow new
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBStringMorph new contents: aLabelString);
		addMorphBack: aBlock)