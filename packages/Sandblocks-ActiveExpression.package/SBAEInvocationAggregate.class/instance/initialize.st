initialization
initialize

	super initialize.
	
	self
		count: 0;
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		listDirection: #leftToRight;
		cellGap: 4 withScalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			addMorphBack: (image := ImageMorph new
				on: #click send: #openStack to: self;
				yourself);
			addMorphBack: (countLabel := SBBadge new
				disableLayout: true;
				visible: false;
				yourself);
			addMorphBack: (resultLabel := SBStringMorph new);
			yourself)