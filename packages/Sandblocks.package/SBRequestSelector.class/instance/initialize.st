as yet unclassified
initialize

	super initialize.
	
	cancelled := true.
	colorPolicy := SBDefaultColorPolicy new.
	
	self
		changeTableLayout;
		color: Color white;
		vResizing: #spaceFill;
		hResizing: #spaceFill;
		addMorphBack: (editor := SBEditor new
			hResizing: #spaceFill;
			vResizing: #spaceFill;
			saveAction: [cancelled := false. self owner delete])