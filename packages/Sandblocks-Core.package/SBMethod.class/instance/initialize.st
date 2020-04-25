as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		cellPositioning: #topLeft;
		layoutInset: 6 withScalingFactor;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap;
		
		addMorphBack: (SBRow new
			addMorphBack: (classPrefix := SBStringMorph new);
			addMorphBack: (signature := SBSignature new))