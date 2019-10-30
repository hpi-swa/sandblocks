as yet unclassified
initialize

	super initialize.
	
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		layoutPolicy: SBVerticalLayout new;
		color: Color transparent.
		
	overlayDrawBlocks := OrderedCollection new