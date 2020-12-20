as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBButton new label: 'Test Request' shortcut: nil do: [self testRequest]);
		attachDecorator: SBMoveDecorator new