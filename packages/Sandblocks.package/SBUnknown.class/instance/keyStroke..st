as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	char isDigit ifTrue: [^ self replaceBy: (SBNumber new contents: char asString)].
	(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replaceBy: (SBBinding new contents: char asString)].
	char = $$ ifTrue: [^ self replaceBy: (SBCharacter new contents: '')].
	char = $' ifTrue: [^ self replaceBy: (SBString new contents: '')].
	char = Character space ifTrue: [^ self replaceBy: (SBMessageSend new receiver: self selector: #'')].
	char = ${ ifTrue: [^ self replaceBy: (SBArray new type: #dynamic contents: {self})].
	char = $# ifTrue: [^ self replaceBy: (SBSymbol new contents: '')].
	char = $[ ifTrue: [^ self replaceBy: (SBBlockBody new statements: {self})].
	char = $: ifTrue: [^ self replaceBy: (SBAssignment new binding: (SBBinding new name: '') value: SBUnknown new)]