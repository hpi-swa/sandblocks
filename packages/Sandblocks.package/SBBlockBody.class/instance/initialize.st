as yet unclassified
initialize

	super initialize.
	
	bindings := Morph new
		color: Color transparent;
		layoutPolicy: SBExpressionLayout new;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 2;
		cellInset: 2;
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