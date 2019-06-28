as yet unclassified
initialize

	super initialize.
	
	self changeTableLayout.
	self listDirection: #topToBottom.
	self vResizing: #shrinkWrap; hResizing: #shrinkWrap.
	
	signature := SBSignature new.
	self addMorphBack: signature