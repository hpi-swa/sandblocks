as yet unclassified
initialize

	super initialize.
	
	connectedLinks := OrderedCollection new.
	
	self
		changeTableLayout;
		listCentering: #topLeft;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		color: Color transparent;
		addMorphBack: (socket := SBSocketCircle new);
		addMorphBack: (label := StringMorph new);
		label: ''