initialization
initialize

	super initialize.
	
	expressions := OrderedDictionary new.
	
	self
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		extent: 0 @ 0;
		color: Color transparent;
		changeTableLayout;
		hResizing: #spaceFill;
		vResizing: #shrinkWrap;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellGap: 4 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (marble := SBMarble new);
			addMorphBack: (expressionIndex := SBConstrainedNumberInput new
				color: Color white;
				value: 1;
				min: 1;
				onChange: [:num | self expressionIndex: num];
				yourself);
			addMorphBack: (SBIcon iconCrosshairs
				on: #click send: #filterMorph to: self;
				balloonText: 'Pick Morph';
				yourself);
			addMorphBack: (SBIcon iconAnchor
				on: #click send: #showDependencies to: self;
				balloonText: 'Show Dependencies';
				yourself);
			addMorphBack: (SBIcon iconShare
				on: #click send: #showSubscribers to: self;
				balloonText: 'Show Subscribers';
				yourself);
			addMorphBack: (SBIcon iconSearch
				on: #click send: #exploreSubject to: self;
				balloonText: 'Explore Subject';
				yourself);
			yourself);
		addMorphBack: (invocations := SBColum new)