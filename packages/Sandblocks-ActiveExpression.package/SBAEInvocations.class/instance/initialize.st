as yet unclassified
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
		cellGap: 4 * self scalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (marble := SBMarble new);
			addMorphBack: (expressionIndex := SBConstrainedNumberInput new
				color: Color white;
				value: 1;
				min: 1;
				onChange: [:num | self expressionIndex: num]);
			addMorphBack: (SBIcon iconCrosshairs on: #click send: #filterMorph to: self);
			addMorphBack: (SBIcon iconShare on: #click send: #showSubscribers to: self));
		addMorphBack: (invocations := SBColum new)