as yet unclassified
acceptCharacter: char

	(char isDigit or: [char = $-]) ifTrue: [^ self doReplaceBy: (SBNumber new contents: char asString)].
	(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self doReplaceBy: (SBBinding new contents: char asString)].
	char = $$ ifTrue: [^ self doReplaceBy: (SBCharacter new contents: '')].
	char = $' ifTrue: [^ self doReplaceBy: (SBString new contents: '')].
	char = Character space ifTrue: [^ self doReplaceBy: (SBMessageSend new receiver: self selector: #'' arguments: #())].
	char = $# ifTrue: [^ self doReplaceBy: (SBSymbol new contents: '')].
	
	char = ${ ifTrue: [^ self doWrap: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBArray new].
	char = $[ ifTrue: [^ self doWrap: [:outer :inner | outer statements: {inner}] with: SBBlockBody new].
	char = $^ ifTrue: [^ self doWrap: [:outer :inner | outer expression: inner] with: SBReturn new]