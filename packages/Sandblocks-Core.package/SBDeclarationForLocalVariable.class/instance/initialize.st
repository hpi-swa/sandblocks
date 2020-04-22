as yet unclassified
initialize

	super initialize.
	
	self attachDecorator: (SBReportedValueDecorator new label: [binding value asString])