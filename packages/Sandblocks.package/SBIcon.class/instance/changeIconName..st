colors
changeIconName: anIconNameSymbol

	self svg: (ECSIcon perform: (anIconNameSymbol ifNil: [#iconEmpty])) svg.
	
	cachedForm := nil.
	iconName := anIconNameSymbol.
	self changed