as yet unclassified
body: aBlock

	super body: aBlock.
	
	self statements
		detect: [:s | s isPragma and: [self class validMethods includes: s selector]]
		ifFound: [:pragma |
			pragma delete.
			self methodInput object: pragma selector allButLast asSymbol.
			self pathArray addMorphBack: pragma arguments first].
	
	self addMorphBack: (SBRatPackRequestLog new
		serverClass: self rpApplication;
		handlerSelector: self selector;
		yourself).