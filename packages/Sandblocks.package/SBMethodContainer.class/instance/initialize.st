as yet unclassified
initialize

	super initialize.
	
	self
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutPolicy: SBVerticalLayout new;
		color: Color transparent.
		
	overlayDrawBlocks := OrderedCollection new