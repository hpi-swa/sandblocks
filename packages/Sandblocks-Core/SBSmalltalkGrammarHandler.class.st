Class {
	#name : #SBSmalltalkGrammarHandler,
	#superclass : #Object,
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
	
	char = Character space ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: '' arguments: #()] with: SBMessageSend new].
	char isSpecial ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer receiver: inner selector: char asString arguments: {SBUnknown new}] with: SBMessageSend new].
	char = ${ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #dynamic contents: {inner}] with: SBArray new].
	char = $( ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer type: #literal contents: {inner}] with: SBArray new].
	char = $[ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer statements: {inner}] with: SBBlockBody new].
	char = $^ ifTrue: [^ self wrap: aBlock do: [:outer :inner | outer expression: inner] with: SBReturn new].
	
	char = Character cr ifTrue: [
		ActiveEvent shiftPressed ifTrue: [aBlock insertStatementAbove] ifFalse: [aBlock insertStatementBelow]]
]

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> replace: aBlock with: aMorph [

	aBlock stopEditing.
	aBlock replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph
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

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> tryDelete: aBlock [

	| editor p |
	p := aBlock previousBlock.
	editor := aBlock sandblockEditor.
	
	aBlock deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBSmalltalkGrammarHandler >> wrap: aBlock do: aWrapBlock with: aNode [

	| cursorIndex |
	cursorIndex := aBlock currentTextMorph ifNotNil: #cursor ifNil: [9e8].
	
	aBlock sandblockEditor
		endInput;
		do: ((SBWrapCommand newFor: aBlock containingArtefact)
			inner: aBlock;
			outer: aNode;
			shouldMergeWithNext: true;
			wrap: aWrapBlock).
	
	" try going into input mode for the new block and otherwise stay within our old block "
	aBlock sandblockEditor startInput: aNode at: 9e8 replacingContents: false.
	aBlock sandblockEditor mode ~= #input ifTrue: [
		aBlock sandblockEditor startInput: aBlock at: cursorIndex replacingContents: false]
]
