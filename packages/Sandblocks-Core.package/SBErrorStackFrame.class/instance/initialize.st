as yet unclassified
initialize

	super initialize.
	
	valueDecorators := OrderedCollection new.
	
	self
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		changeTableLayout