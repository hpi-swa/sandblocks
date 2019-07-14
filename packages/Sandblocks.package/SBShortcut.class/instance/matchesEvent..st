as yet unclassified
matchesEvent: anEvent

	^ anEvent keyCharacter = character
		and: [ctrl = anEvent controlKeyPressed]
		and: [command = anEvent commandKeyPressed]
		and: [shift not or: [anEvent shiftPressed]]