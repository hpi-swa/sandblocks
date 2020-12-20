*Sandblocks-Core
representationsThat: aSymbol do: aBlock deep: aBoolean

	SBExample self: ['5+5' parseAsSandblock] args: [{#isToplevelMorph. [:repr | nil]. true}] label: 'simple'.
	aSymbol ifNil: [^ self].
	aSymbol isSymbol ifFalse: [
		^ aSymbol do: [:sym | self representationsThat: sym do: aBlock]].
	SBRepresentation representationsDo: [:repr |
		((repr supports: aSymbol) and: [repr matches: self]) ifTrue: [aBlock value: repr].
		
		((aBoolean isBoolean not and: [aBoolean < 3]) and: [
			repr identity not and: [repr isLeaf not and: [repr matches: self]]]) ifTrue: [ | nested |
			(nested := repr eagerNewFor: self) ~= self ifTrue: [
				nested
					representationsThat: aSymbol
					do: [:nestedRepr |
						aBlock value: (SBDerivedRepresentation from: repr to: nestedRepr)]
					deep: aBoolean + 1]]] for: self