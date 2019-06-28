as yet unclassified
initialize

	super initialize.
	
	self changeTableLayout.
	self listDirection: #leftToRight.
	self hResizing: #shrinkWrap.
	self vResizing: #shrinkWrap.
	
	signature := SBSignature new.
	self addMorphBack: signature