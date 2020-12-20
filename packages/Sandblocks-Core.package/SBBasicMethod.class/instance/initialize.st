as yet unclassified
initialize

	super initialize.
	
	self
		hasUnsavedChanges: false;
		attachDecorator: SBMoveDecorator new