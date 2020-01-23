as yet unclassified
initialize

	super initialize.
	self extent: self class marbleSize.
	self on: #click send: #showSideEffects to: self