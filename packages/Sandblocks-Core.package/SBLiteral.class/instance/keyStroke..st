as yet unclassified
keyStroke: anEvent

	(anEvent keyCharacter isSpecial or: [anEvent keyCharacter = Character space]) ifTrue: [
		^ self sandblockEditor
			endInput;
			wrapInMessageSend: (anEvent keyCharacter isSpecial ifTrue: [anEvent keyCharacter asString] ifFalse: [''])].
	
	"anEvent keyCharacter = Character tab ifTrue: [
		^ (anEvent shiftPressed
			ifTrue: [self previousAdjacentMorphThat: [:m | m isSandblock and: [m isLiteralBlock]]]
			ifFalse: [self nextAdjacentMorphThat: [:m | m isSandblock and: [m isLiteralBlock]]]) ifNotNil: [:m |
				self sandblockEditor
					select: m;
					startInput: m at: 0 replacingContents: false]]."
	
	self acceptInputEvent: anEvent