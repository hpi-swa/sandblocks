as yet unclassified
initialize

	super initialize.
	self
		useAlgebraLayout;
		layoutInset: 6 withScalingFactor;
		cellGap: 8 withScalingFactor;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: (selectorInput := SBTextBubble new
				colored: false;
				layoutInset: 5 withScalingFactor;
				yourself);
			addMorphBack: (SBIcon iconPlay on: #click send: #runTest to: self);
			addMorphBack: (Morph new
				width: 6;
				height: 0;
				color: Color transparent;
				yourself);
			addMorphBack: (passIcon := SBIcon iconQuestion
				color: Color white;
				yourself);
			addMorphBack: (Morph new
				width: 6;
				height: 0;
				color: Color transparent;
				yourself);
			addMorphBack: (autoRun := SBCheckbox new
				value: true;
				nonEdit: true;
				when: #toggled send: #sendStopNotification to: self);
			addMorphBack: (SBStringMorph new contents: 'Auto-run');
			yourself);
		attachDecorator: SBResizableDecorator new