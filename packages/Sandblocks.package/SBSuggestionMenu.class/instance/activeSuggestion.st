as yet unclassified
activeSuggestion

	^ self hasSubmorphs ifFalse: [nil] ifTrue: [self submorphs at: activeIndex]