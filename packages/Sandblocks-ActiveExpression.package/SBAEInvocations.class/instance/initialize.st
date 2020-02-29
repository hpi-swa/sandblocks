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
			addMorphBack: (SBIcon iconCrosshairs on: #click send: #filterMorph to: self; yourself);
			addMorphBack: (SBIcon iconShare on: #click send: #showSubscribers to: self; yourself);
			addMorphBack: (SBIcon iconSearch on: #click send: #exploreSubject to: self; yourself);
			yourself);
		addMorphBack: (invocations := SBColum new)