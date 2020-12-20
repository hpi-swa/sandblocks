as yet unclassified
addUponEnter: aBlock

	self addMorphBack: (SBRow new
		 cellGap: 4 withScalingFactor;
		 addMorphBack: (SBStringMorph new contents: 'Enter:');
		 addMorphBack: aBlock)