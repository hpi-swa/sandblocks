as yet unclassified
keyStroke: anEvent

	anEvent keyCharacter = Character tab ifTrue: [
		currentInputMessagePart stopEditing.
		currentInputMessagePart := self submorphs atWrap: (self submorphIndexOf: currentInputMessagePart) + 2.
		currentInputMessagePart moveCursorTo: 1.
		^ self].
	
	currentInputMessagePart keyStroke: anEvent