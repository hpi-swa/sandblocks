as yet unclassified
reportValue: anObject for: anExample

	exampleValues
		at: anExample
		ifPresent: [:display | display reportValue: anObject name: (anExample ifNotNil: #label ifNil: [''])]