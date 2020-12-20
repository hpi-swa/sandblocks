as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap.
	
	self on: #keyStroke send: #keyStroke: to: self