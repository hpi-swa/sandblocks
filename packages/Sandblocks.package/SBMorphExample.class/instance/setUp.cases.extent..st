as yet unclassified
setUp: aBlock cases: aCollectionOfBlocks extent: aPoint

	self addMorph: (SBRow new
		cellGap: 4 * self scalingFactor;
		addMorphBack: (SBStringMorph new contents: 'Setup:');
		addMorphBack: (aBlock statements first);
		addMorphBack: (SBIcon iconSpinner
			balloonText: 'Toggle stepping';
			on: #click send: #toggleStepping to: self)).
	
	aCollectionOfBlocks do: [:m | self addCase: m arguments second name: m arguments first contents].
	
	view extent: aPoint