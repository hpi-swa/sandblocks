as yet unclassified
color

	^ self owner ifNotNil: [:o | o containingSandblock color adjustSaturation: -0.1 brightness: 0.1] ifNil: [Color white]