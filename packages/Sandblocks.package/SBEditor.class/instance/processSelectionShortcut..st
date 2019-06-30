events
processSelectionShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	currentInput ifNotNil: [
		char = Character escape ifTrue: [^ self endInput].
		^ currentInput keyStroke: anEvent].
	
	(char = Character tab or: [char = $l]) ifTrue: [^ self selectNext].
	((char = Character tab and: [anEvent shiftPressed]) or: [char = $h]) ifTrue: [^ self selectPrevious].
	char = Character arrowUp ifTrue: [^ self selectUp].
	char = Character arrowDown ifTrue: [^ self selectDown].
	char = $d ifTrue: [^ self do: (SBReplaceCommand target: self selection parentSandblock replacer: self selection)].
	char = $x ifTrue: [self setCopyBuffer: self selection. ^ self do: (SBReplaceCommand target: self selection replacer: SBUnknown new)].
	char = $u ifTrue: [^ self undo].
	char = $i ifTrue: [^ self startInput: self selection at: 1 replacing: false].
	char = $a ifTrue: [^ self startInput: self selection at: 9e8 replacing: false].
	char = $s ifTrue: [^ self startInput: self selection at: 1 replacing: true].
	char = $o ifTrue: [^ self insertStatementAboveOrBelow: false].
	char = $O ifTrue: [^ self insertStatementAboveOrBelow: true].
	char = Character space ifTrue: [^ self wrapInMessageSend].
	char = $[ ifTrue: [^ self wrapInBlock].
	char = $y ifTrue: [^ self setCopyBuffer: self selection].
	char = $= ifTrue: [^ self replaceWithCopyBuffer].
	
	anEvent commandKeyPressed ifTrue: [
		char = $r ifTrue: [^ self redo].
		char = $w ifTrue: [^ self watchExpression: selection]]