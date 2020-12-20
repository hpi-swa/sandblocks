as yet unclassified
moveActive: aNumber

	self hasSubmorphs ifFalse: [^ self].
	
	(self submorphs at: activeIndex) active: false.
	activeIndex := activeIndex + aNumber clampLow: 1 high: self submorphCount.
	(self submorphs at: activeIndex) active: true