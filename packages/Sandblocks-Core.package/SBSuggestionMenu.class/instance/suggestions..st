as yet unclassified
suggestions: aCollectionOfSymbol

	self removeAllMorphs.
	
	aCollectionOfSymbol do: [:item |
		self addMorphBack: item].
	
	self hasSubmorphs ifTrue: [
		activeIndex := activeIndex min: self submorphCount.
		(self submorphs at: activeIndex) active: true]