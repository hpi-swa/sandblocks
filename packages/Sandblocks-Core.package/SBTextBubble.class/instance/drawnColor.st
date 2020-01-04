as yet unclassified
drawnColor

	^ self colored ifTrue: [super drawnColor] ifFalse: [self parentSandblock drawnColor]