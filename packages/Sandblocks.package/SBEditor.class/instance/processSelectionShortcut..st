events
processSelectionShortcut: anEvent

	| char |
	char := anEvent keyCharacter.
	
	((char = Character tab and: [anEvent shiftPressed]) or: [char = $h]) ifTrue: [^ self selectPrevious].
	(char = Character tab or: [char = $l]) ifTrue: [^ self selectNext].
	char = $H ifTrue: [self swapLeft].
	char = $L ifTrue: [self swapRight].
	(char = $k or: [char = Character arrowUp]) ifTrue: [^ self selectUp].
	(char =$j or: [char = Character arrowDown]) ifTrue: [^ self selectDown].
	char = $d ifTrue: [^ self deleteAroundSelection].
	char = $x ifTrue: [self deleteSelection].
	char = $+ ifTrue: [^ self addElement].
	char = $i ifTrue: [^ self startInput: self selection at: 1 replacingContents: false].
	char = $a ifTrue: [^ self startInput: self selection at: 9e8 replacingContents: false].
	char = $s ifTrue: [^ self startInput: self selection at: 1 replacingContents: true].
	char = $o ifTrue: [^ self insertStatementAboveOrBelow: false].
	char = $O ifTrue: [^ self insertStatementAboveOrBelow: true].
	char = Character space ifTrue: [^ self wrapInMessageSend].
	char = $[ ifTrue: [^ self wrapInBlock].
	char = $y ifTrue: [^ self setCopyBuffer: self selection].
	char = $r ifTrue: [^ self replaceWithCopyBuffer].
	char = $p ifTrue: [^ self pasteStatementAboveOrBelow: false].
	char = $P ifTrue: [^ self pasteStatementAboveOrBelow: true].
	char = $: ifTrue: [^ self wrapInAssignment].
	char = $^ ifTrue: [^ self wrapInReturn].
	char = ${ ifTrue: [^ self wrapInArrayType: #dynamic].
	char = $# ifTrue: [^ self wrapInArrayType: #literal].
	char = $= ifTrue: [^ self extractVariable].
	
	anEvent commandKeyPressed ifTrue: [
		char = $c ifTrue: [self copyString].
		char = $v ifTrue: [self pasteString].
		char = $w ifTrue: [^ self watchExpression: self selection]]