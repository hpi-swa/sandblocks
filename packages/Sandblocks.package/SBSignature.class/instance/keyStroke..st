as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	(char = Character tab or: [char = Character space]) ifTrue: [^ self moveFocusToNextPart: (anEvent shiftPressed ifTrue: [-1] ifFalse: [1])].
	
	char = $: ifTrue: [^ self addMessagePart].
	(char isSpecial and: [currentInputMessagePart contents isEmpty])
		ifTrue: [^ self setBinaryMessage: char asString].
	
	(char = $+ and: [anEvent controlKeyPressed] and: [self isKeyword]) ifTrue: [
		^ self addMessagePart: ':' after: currentInputMessagePart submorphAfter focusKeyword: nil].
	
	self isBinary
		ifTrue: [
			char isSpecial
				ifTrue: [currentInputMessagePart keyStroke: anEvent]
				ifFalse: [
					self moveFocusToNextPart: 1.
					self sandblockEditor selection keyStroke: anEvent]]
		ifFalse: [currentInputMessagePart keyStroke: anEvent]