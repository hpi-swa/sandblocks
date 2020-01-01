as yet unclassified
active: aBoolean

	active := aBoolean.
	activeIcon color: (aBoolean ifTrue: [Color red lighter] ifFalse: [Color white alpha: 0.7])