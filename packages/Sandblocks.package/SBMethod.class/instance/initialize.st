as yet unclassified
initialize

	super initialize.
	
	self
		layoutPolicy: SBVerticalLayout new;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	
	signature := SBSignature new.
	self addMorphBack: signature