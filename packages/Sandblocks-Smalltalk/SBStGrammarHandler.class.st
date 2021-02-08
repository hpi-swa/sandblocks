Class {
	#name : #SBStGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStGrammarHandler >> emptyLine: aBlock [
	<action>
	<actionValidIf: #isStatement>
	
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: SBStEmptyLine new)
]

{ #category : #'as yet unclassified' }
SBStGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	aBoolean ifTrue: [
		(char isDigit or: [char = $-]) ifTrue: [^ self replace: aBlock with: (SBStNumber new contents: char asString)].
		(char isAlphaNumeric or: [char = $_]) ifTrue: [^ self replace: aBlock with: (SBStName contents: char asString)].
		char = $$ ifTrue: [^ self replace: aBlock with: (SBStCharacter new contents: '')].
		char = $' ifTrue: [^ self replace: aBlock with: (SBStString new contents: '')].
		char = $# ifTrue: [^ self replace: aBlock with: (SBStSymbol new contents: '')].
		((char = Character space or: [char = Character cr]) and: [aBlock isStatement]) ifTrue: [^ self emptyLine: aBlock].
		(char = $: and: [aBlock parentSandblock isBlockBody and: [aBlock parentSandblock isMethodBody not]]) ifTrue: [ | block |
			block := aBlock parentSandblock.
			aBlock parentSandblock statements size > 1 ifTrue: [
				aBlock sandblockEditor do: ((SBDeleteCommand newFor: aBlock containingArtefact) target: aBlock; shouldMergeWithNext: true)].
			^ block addBlockArgument].
	char = $< ifTrue: [^ self replaceWithPragma: aBlock].
	char = Character backspace ifTrue: [^ self tryDelete: aBlock]].
	
	char = Character space ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: '' arguments: #()] with: SBStMessageSend new focusOuter: true].
	char isSpecial ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: char asString arguments: {outer newNullBlock}] with: SBStMessageSend new focusOuter: true].
	char = ${ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBStArray new].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBStArray new].
	char = $[ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer statements: {inner}] with: SBStBlockBody new].
	char = $^ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer expression: inner] with: SBStReturn new].
	
	char = Character cr ifTrue: [
		ActiveEvent shiftPressed ifTrue: [aBlock insertStatementAbove] ifFalse: [aBlock insertStatementBelow]]
]

{ #category : #'as yet unclassified' }
SBStGrammarHandler >> replaceWithPragma: aBlock [

	| pragma |
	pragma := SBStPragma new.
	aBlock stopEditing.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true
]
