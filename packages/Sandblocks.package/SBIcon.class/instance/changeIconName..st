colors
changeIconName: anIconNameSymbol

	self svg: (SBIcon perform: (anIconNameSymbol ifNil: [#iconEmpty])) svg.
	
	cachedForm := nil.
	iconName := anIconNameSymbol.
	self changed