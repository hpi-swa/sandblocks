as yet unclassified
promptChangeDisplay

	| index options |
	options := lastValue representationsThat: self representationTypes.
	index := UIManager default chooseFrom: options.
	index = 0 ifTrue: [^ self].
	
	currentRepresentation := options at: index.
	
	self useDisplay: (currentRepresentation newFor: lastValue)