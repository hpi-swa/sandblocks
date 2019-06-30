as yet unclassified
keyStroke: anEvent

	| char |
	char := anEvent keyCharacter.
	char isDigit ifTrue: [^ self doReplaceBy: (SBNumber new contents: char asString)].
	(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self doReplaceBy: (SBBinding new contents: char asString)].
	char = $$ ifTrue: [^ self doReplaceBy: (SBCharacter new contents: '')].
	char = $' ifTrue: [^ self doReplaceBy: (SBString new contents: '')].
	char = Character space ifTrue: [^ self doReplaceBy: (SBMessageSend new receiver: self selector: #'' arguments: #())].
	char = ${ ifTrue: [^ self doReplaceBy: (SBArray new type: #dynamic contents: {self})].
	char = $# ifTrue: [^ self doReplaceBy: (SBSymbol new contents: '')].
	char = $[ ifTrue: [^ self doReplaceBy: (SBBlockBody new statements: {self})].
	char = $: ifTrue: [^ self doReplaceBy: (SBAssignment new binding: (SBBinding new name: '') value: SBUnknown new)]