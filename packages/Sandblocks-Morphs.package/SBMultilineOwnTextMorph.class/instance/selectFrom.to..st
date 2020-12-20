as yet unclassified
selectFrom: aNumber to: anotherNumber

	self
		cursor: (anotherNumber clampLow: 1 high: self contents size + 1);
		selectionBound: (aNumber clampLow: 1 high: self contents size + 1)