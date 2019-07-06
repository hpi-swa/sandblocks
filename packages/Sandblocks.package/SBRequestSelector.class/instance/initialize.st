as yet unclassified
initialize

	super initialize.
	
	cancelled := true.
	
	self
		changeTableLayout;
		color: Color white;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addMorphBack: (editor := SBEditor new saveAction: [cancelled := false. self owner delete])