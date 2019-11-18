as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		cellPositioning: #topLeft;
		layoutInset: 12 * self scalingFactor;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	
	signature := SBSignature new.
	self addMorphBack: signature