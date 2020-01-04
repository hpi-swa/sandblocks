as yet unclassified
initialize

	super initialize.
	
	self
		cellPositioning: #topLeft;
		layoutPolicy: SBVerticalLayout new;
		color: Color transparent;
		layoutInset: 0.
		
	overlayDrawBlocks := OrderedCollection new