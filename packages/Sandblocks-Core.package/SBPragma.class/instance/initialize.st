as yet unclassified
initialize

	super initialize.
	self
		addMorphBack: (signature := SBSignature new
			selector: 'pragma';
			yourself)