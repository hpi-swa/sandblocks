as yet unclassified
initialize

	super initialize.
	
	bindings := SBBlockBindings new.
	temporaries := SBTemporaries new.
	
	self
		layoutPolicy: SBBlockBodyLayout new;
		color: Color random;
		cellPositioning: #topLeft;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: bindings;
		addMorphBack: temporaries