as yet unclassified
initialize

	super initialize.
	self
		 layoutPolicy: SBVerticalLayout new;
		 layoutInset: 6 withScalingFactor;
		 cellGap: 8 withScalingFactor;
		 hResizing: #shrinkWrap;
		 vResizing: #shrinkWrap;
		 addMorphBack: (SBRow new cellGap: 8 withScalingFactor; addMorphBack: (SBStringMorph new contents: 'Original:'));
		 addMorphBack: (SBRow new cellGap: 8 withScalingFactor; addMorphBack: (SBStringMorph new contents: 'Replace:'))