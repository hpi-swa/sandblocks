as yet unclassified
keyDown: anEvent

	anEvent keyCharacter = Character tab
		ifTrue: [
			anEvent shiftPressed
				ifTrue: [self focusPreviousMorph: anEvent]
				ifFalse: [self focusNextMorph: anEvent]]
		ifFalse: [^ super keyDown: anEvent]