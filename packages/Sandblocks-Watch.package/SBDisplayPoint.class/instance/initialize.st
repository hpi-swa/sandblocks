as yet unclassified
initialize

	super initialize.
	
	pointers := #().
	
	self
		on: #mouseEnter send: #showPoint to: self;
		on: #mouseLeave send: #hidePoint to: self;
		changeTableLayout;
		listDirection: #leftToRight;
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (direction := ImageMorph new image: (Form extent: 24 asPoint depth: 32))