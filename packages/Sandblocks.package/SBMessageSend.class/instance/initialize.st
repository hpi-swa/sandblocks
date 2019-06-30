as yet unclassified
initialize

	super initialize.
	
	self layoutPolicy: SBHorizontalLayout new.
	self listDirection: #leftToRight.
	self hResizing: #shrinkWrap.
	self vResizing: #shrinkWrap.
	self cellInset: 2.
	
	signature := SBSignature new.
	self addMorphBack: signature