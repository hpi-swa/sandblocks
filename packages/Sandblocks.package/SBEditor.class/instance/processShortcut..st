as yet unclassified
processShortcut: anEvent

	anEvent commandKeyPressed ifTrue: [
		^ anEvent keyCharacter = $w ifTrue: [self watchExpression: selection]].