as yet unclassified
initialize

	super initialize.
	
	bindings := SBBlockBindings new.
	temporaries := SBTemporaries new.
	pc := 0.
	
	self
		color: Color random;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			layoutPolicy: SBAlgebraLayout new;
			addMorphBack: bindings;
			addMorphBack: temporaries)