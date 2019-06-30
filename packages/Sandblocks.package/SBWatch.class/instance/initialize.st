as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		cellInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (display := SBStringMorph new color: Color white; contents: '...')