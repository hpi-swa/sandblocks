as yet unclassified
mouseDown: anEvent

	anEvent yellowButtonPressed
		ifTrue: [cuttingMoving := true]
		ifFalse: [super mouseDown: anEvent]