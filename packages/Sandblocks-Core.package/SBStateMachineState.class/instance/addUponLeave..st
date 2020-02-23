as yet unclassified
addUponLeave: aBlock

	self addMorphBack: (SBRow new
		 cellGap: 4 withScalingFactor;
		 addMorphBack: (SBStringMorph new contents: 'Leave:');
		 addMorphBack: aBlock)