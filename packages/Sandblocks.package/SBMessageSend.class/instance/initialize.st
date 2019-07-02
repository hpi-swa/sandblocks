as yet unclassified
initialize

	super initialize.
	
	self layoutPolicy: SBMessageReceiverLayout new.
	self listDirection: #leftToRight.
	self hResizing: #shrinkWrap.
	self vResizing: #shrinkWrap.
	self cellInset: 2 * self scalingFactor.
	
	signature := SBSignature new.
	self addMorphBack: signature