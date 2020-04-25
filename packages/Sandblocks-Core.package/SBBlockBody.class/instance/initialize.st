as yet unclassified
initialize

	super initialize.
	
	bindings := SBBlockBindings new.
	temporaries := SBTemporaries new.
	pc := 0.
	
	self
		layoutPolicy: SBBlockBodyLayout new;
		minimumHeight: TextStyle defaultFont height + self layoutInset vertical;
		color: Color random;
		cellPositioning: #topLeft;
		cellPositioning: #topLeft;
		listDirection: #topToBottom;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		addMorphBack: (SBRow new
			cellGap: 8 withScalingFactor;
			addMorphBack: bindings;
			addMorphBack: temporaries)