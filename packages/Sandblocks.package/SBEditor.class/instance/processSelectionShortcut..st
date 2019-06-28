as yet unclassified
processSelectionShortcut: anEvent

	anEvent commandKeyPressed ifTrue: [
		^ anEvent keyCharacter = $w ifTrue: [self watchExpression: selection]].