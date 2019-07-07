as yet unclassified
acceptCharacter: char

	char isDigit ifTrue: [^ self doReplaceBy: (SBNumber new contents: char asString)].
	(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self doReplaceBy: (SBBinding new contents: char asString)].
	char = $$ ifTrue: [^ self doReplaceBy: (SBCharacter new contents: '')].
	char = $' ifTrue: [^ self doReplaceBy: (SBString new contents: '')].
	char = Character space ifTrue: [^ self doReplaceBy: (SBMessageSend new receiver: self selector: #'' arguments: #())].
	char = ${ ifTrue: [^ self doReplaceBy: (SBArray new type: #dynamic contents: {self})].
	char = $# ifTrue: [^ self doReplaceBy: (SBSymbol new contents: '')].
	
	char = $[ ifTrue: [ 
		self sandblockEditor
			endInput;
			do: (SBWrapCommand new
				inner: self;
				outer: SBBlockBody new;
				shouldMergeWithNext: true;
				wrap: [:outer :inner | outer statements: {inner}]);
			startInput: self at: 0 replacingContents: false]