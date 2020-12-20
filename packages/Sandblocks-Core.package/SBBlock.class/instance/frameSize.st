as yet unclassified
frameSize

	^ self colorPolicy ifNotNil: [:c | c selectionBorderWidth] ifNil: [0]