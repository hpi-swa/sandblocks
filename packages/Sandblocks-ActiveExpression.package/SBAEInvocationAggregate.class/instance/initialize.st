accessing
initialize

	super initialize.
	
	self
		count: 0;
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		cellGap: 4 * self scalingFactor;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		on: #click send: #openStack to: self;
		addMorphBack: (image := ImageMorph new);
		addMorphBack: (countLabel := SBBadge new disableLayout: true; visible: false);
		addMorphBack: (SBIcon iconFire on: #click send: #showSideEffects to: self);
		addMorphBack: (resultLabel := SBStringMorph new)