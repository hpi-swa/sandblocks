accessing
initialize

	super initialize.
	
	self
		count: 0;
		color: Color transparent;
		layoutPolicy: SBVerticalLayout new;
		listDirection: #leftToRight;
		cellGap: 4 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			addMorphBack: (image := ImageMorph new
				on: #click send: #openStack to: self;
				yourself);
			addMorphBack: (countLabel := SBBadge new disableLayout: true; visible: false);
			"addMorphBack: (sideEffectsIcon := SBIcon iconFire
				on: #click send: #showSideEffects to: self;
				visible: false);"
			addMorphBack: (resultLabel := SBStringMorph new))