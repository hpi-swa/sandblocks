Class {
	#name : #SBSmalltalkGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> emptyLine: aBlock [
	<action>
	<actionValidIf: #isStatement>
	
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: SBEmptyLine new)
]

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> perform: char for: aBlock empty: aBoolean [

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
	char = Character backspace ifTrue: [^ self tryDelete: aBlock]].
	
	char = Character space ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: '' arguments: #()] with: SBMessageSend new focusOuter: true].
	char isSpecial ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: char asString arguments: {outer newNullBlock}] with: SBMessageSend new focusOuter: true].
	char = ${ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBArray new].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBArray new].
	char = $[ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer statements: {inner}] with: SBBlockBody new].
	char = $^ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer expression: inner] with: SBReturn new].
	
	char = Character cr ifTrue: [
		ActiveEvent shiftPressed ifTrue: [aBlock insertStatementAbove] ifFalse: [aBlock insertStatementBelow]]
]

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> replaceWithPragma: aBlock [

	| pragma |
	pragma := SBPragma new.
	aBlock stopEditing.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		target: aBlock;
		replacer: pragma;
		shouldMergeWithNext: true).
	^ pragma sandblockEditor startInput: pragma at: 1 replacingContents: true
]
