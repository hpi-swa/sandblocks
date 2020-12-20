as yet unclassified
drawnColor

	^ self colored ifTrue: [super drawnColor] ifFalse: [Color transparent]