as yet unclassified
initialize

	super initialize.
	
	bindings := SBBlock new
		layoutPolicy: SBExpressionLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		extent: 0 @ 0;
		yourself.
	temporaries := SBTemporaries new.
	
	self
		layoutPolicy: SBBlockLayout new;
		color: Color random;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: bindings;
		addMorphBack: temporaries