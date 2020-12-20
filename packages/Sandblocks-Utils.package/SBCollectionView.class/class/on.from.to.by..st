as yet unclassified
on: aCollection from: aNumber to: anotherNumber by: aThirdNumber

	^ self new
		collection: aCollection;
		start: aNumber;
		end: anotherNumber;
		step: aThirdNumber;
		yourself