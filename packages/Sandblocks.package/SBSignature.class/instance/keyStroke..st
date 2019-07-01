as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character tab ifTrue: [^ self moveFocusToNextPart: (anEvent shiftPressed ifTrue: [-1] ifFalse: [1])].
	anEvent keyCharacter = $: ifTrue: [^ self addMessagePart].
	(anEvent keyCharacter isSpecial and: [currentInputMessagePart contents isEmpty])
		ifTrue: [^ self setBinaryMessage: anEvent keyCharacter asString].
	
	currentInputMessagePart keyStroke: anEvent