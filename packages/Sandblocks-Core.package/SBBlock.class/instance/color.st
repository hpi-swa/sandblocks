as yet unclassified
color

	^ self colorPolicy ifNotNil: [:p | p colorForBlock: self] ifNil: [Color white]