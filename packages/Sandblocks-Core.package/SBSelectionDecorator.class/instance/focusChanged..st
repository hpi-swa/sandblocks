as yet unclassified
focusChanged: aBoolean

	blinkCount := aBoolean ifTrue: [0] ifFalse: [self maxBlickCount].
	self morph ifNotNil: #updateSteppingDecorators