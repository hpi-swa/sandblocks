accessing
color

	^ self containingSandblock ifNotNil: [:b | b foregroundColor] ifNil: [super color]