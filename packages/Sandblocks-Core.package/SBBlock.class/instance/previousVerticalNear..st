as yet unclassified
previousVerticalNear: aNumber

	^ self
		nextVerticalNear: aNumber
		calcDistance: [:candidate | self top - candidate bottom]
		validBlock: [:candidate | self top > candidate bottom]