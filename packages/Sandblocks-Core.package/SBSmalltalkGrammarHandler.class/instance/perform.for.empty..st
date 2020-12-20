as yet unclassified
perform: char for: aBlock empty: aBoolean

	aBoolean ifTrue: [
		(char isDigit or: [char = $-]) ifTrue: [^ self replace: aBlock with: (SBNumber new contents: char asString)].
		(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replace: aBlock with: (SBName contents: char asString)].
		char = $$ ifTrue: [^ self replace: aBlock with: (SBCharacter new contents: '')].
		char = $' ifTrue: [^ self replace: aBlock with: (SBString new contents: '')].
		char = $# ifTrue: [^ self replace: aBlock with: (SBSymbol new contents: '')].
		((char = Character space or: [char = Character cr]) and: [aBlock isStatement]) ifTrue: [^ self emptyLine: aBlock].
		(char = $: and: [aBlock parentSandblock isBlockBody and: [aBlock parentSandblock isMethodBody not]]) ifTrue: [ | block |
			block := aBlock parentSandblock.
			aBlock parentSandblock statements size > 1 ifTrue: [
				aBlock sandblockEditor do: ((SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock; shouldMergeWithNext: true)].
			^ block addBlockArgument].
	char = $< ifTrue: [^ self replaceWithPragma: aBlock].
	char = Character backspace ifTrue: [self halt.^ self tryDelete: aBlock]].
	
	char = Character space ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: '' arguments: #()] with: SBMessageSend new].
	char isSpecial ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: char asString arguments: {SBUnknown new}] with: SBMessageSend new].
	char = ${ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBArray new].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBArray new].
	char = $[ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer statements: {inner}] with: SBBlockBody new].
	char = $^ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer expression: inner] with: SBReturn new].
	
	char = Character cr ifTrue: [
		ActiveEvent shiftPressed ifTrue: [aBlock insertStatementAbove] ifFalse: [aBlock insertStatementBelow]]