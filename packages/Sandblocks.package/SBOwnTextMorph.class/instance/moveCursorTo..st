as yet unclassified
moveCursorTo: aNumber

	self cursor: (aNumber clampLow: 1 high: self contents size + 1)