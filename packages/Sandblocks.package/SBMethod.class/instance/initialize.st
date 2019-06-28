as yet unclassified
initialize

	super initialize.
	
	self
		changeTableLayout;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	
	signature := SBSignature new.
	self addMorphBack: signature