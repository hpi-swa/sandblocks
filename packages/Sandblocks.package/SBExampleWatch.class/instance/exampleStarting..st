as yet unclassified
exampleStarting: anExample

	(exampleValues
		at: anExample
		ifAbsentPut: [ | display |
			display := SBExampleValueDisplay new name: anExample name.
			self addMorphBack: (exampleValues at: anExample put: display).
			display]) exampleStarting: anExample