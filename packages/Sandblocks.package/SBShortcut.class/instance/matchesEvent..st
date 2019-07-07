as yet unclassified
matchesEvent: anEvent

	^ anEvent keyCharacter = character
		and: [ctrl not or: [anEvent controlKeyPressed]]
		and: [command not or: [anEvent commandKeyPressed]]
		and: [shift not or: [anEvent shiftPressed]]