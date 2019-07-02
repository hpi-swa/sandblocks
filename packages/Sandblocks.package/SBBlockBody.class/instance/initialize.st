as yet unclassified
initialize

	super initialize.
	
	bindings := Morph new
		color: Color transparent;
		layoutPolicy: SBHorizontalLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2 * self scalingFactor;
		cellInset: 2 * self scalingFactor;
		extent: 0 @ 0;
		yourself.
	
	temporaries := SBTemporaries new.
	
	self
		layoutPolicy: SBBlockBodyLayout new;
		color: Color random;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: bindings;
		addMorphBack: temporaries