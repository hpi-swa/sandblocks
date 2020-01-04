selection
selection

	^ selection ifNotNil: [selection owner ifNil: [nil] ifNotNil: [selection]]