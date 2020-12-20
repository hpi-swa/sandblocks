as yet unclassified
initialize

	super initialize.
	
	pc := 0.
	self addMorphBack: (signature := SBSignature new)