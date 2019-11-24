as yet unclassified
reportValue: anObject for: anExample

	(exampleValues
		at: anExample
		"ifAbsentPut: [ | display |
			display := SBExampleValueDisplay new.
			self addMorphBack: (exampleValues at: anExample put: display).
			display]") reportValue: anObject name: (anExample ifNotNil: #label ifNil: [''])