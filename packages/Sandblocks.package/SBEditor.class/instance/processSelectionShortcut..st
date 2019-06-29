as yet unclassified
processSelectionShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	currentInput ifNotNil: [
		char = Character escape ifTrue: [^ self endInput].
		^ currentInput keyStroke: anEvent].

	(char = Character tab or: [char = $l]) ifTrue: [^ self selectNext].
	((char = Character tab and: [anEvent shiftPressed]) or: [char = $h]) ifTrue: [^ self selectPrevious].
	char = Character arrowUp ifTrue: [^ self select: self selection owner containingSandblock].
	char = Character arrowDown ifTrue: [^ self select: self selection owner containingSandblock].
	char = $d ifTrue: [^ self do: (SBReplaceCommand target: self selection parentSandblock replacer: self selection)].
	char = $u ifTrue: [^ self undo].
	char = $i ifTrue: [^ self startInput: self selection at: 1 replacing: false].
	char = $a ifTrue: [^ self startInput: self selection at: 9e8 replacing: false].
	char = $s ifTrue: [^ self startInput: self selection at: 1 replacing: true].
	char = $o ifTrue: [^ self insertStatementAboveOrBelow: false].
	char = $O ifTrue: [^ self insertStatementAboveOrBelow: true].
	
	anEvent commandKeyPressed ifTrue: [
		char = $r ifTrue: [^ self redo].
		char = $w ifTrue: [^ self watchExpression: selection]]