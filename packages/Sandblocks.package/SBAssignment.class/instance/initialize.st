as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBExpressionLayout new;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		listDirection: #leftToRight