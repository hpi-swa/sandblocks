Class {
	#name : #SBGrammarHandler,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #helper }
SBGrammarHandler class >> eventValidForString: anEvent [

	(anEvent commandKeyPressed or: [anEvent optionKeyPressed or: [anEvent controlKeyPressed]]) ifTrue: [^ false].
	
	({Character arrowDown. Character arrowUp. Character arrowLeft. Character arrowRight} includes: anEvent keyCharacter) ifTrue: [^ false].
	
	^ true
]

{ #category : #'action helpers' }
SBGrammarHandler >> block [

	^ currentBlock
]

{ #category : #'action helpers' }
SBGrammarHandler >> block: aBlock [

	currentBlock := aBlock
]

{ #category : #actions }
SBGrammarHandler >> copyString [
	<action>

	Clipboard clipboardText: self block prettySourceString
]

{ #category : #'callback helpers' }
SBGrammarHandler >> focusNextFrom: aMorph at: aNumber [

	self focusNextFrom: aMorph at: aNumber wasInput: aMorph sandblockEditor mode = #input
]

{ #category : #'callback helpers' }
SBGrammarHandler >> focusNextFrom: aMorph at: aNumber wasInput: aBoolean [

	SBToggledCode
		comment: ''
		active: 1
		do: {
			[
				aMorph sandblockEditor
					endInput;
					startInput: aMorph at: 900000000 replacingContents: false].
			[
				aMorph sandblockEditor mode = #input ifTrue: [
					aMorph sandblockEditor replaceInput: aMorph.
					aMorph currentTextMorph ifNotNil: [:m | m moveCursorTo: aNumber]]].
			[
				aBoolean ifTrue: [
					aMorph sandblockEditor
						endInput;
						startInput: aMorph at: 900000000 replacingContents: false]]
		}.
	
	aMorph sandblockEditor mode = #input ifFalse: [
		(aMorph nextBlockThat: [:m | m isUnknown])
			ifNotNil: [:m |
				aMorph sandblockEditor startInput: m at: aNumber replacingContents: false]
			ifNil: [
				aMorph sandblockEditor startInput: aMorph at: aNumber replacingContents: false]]
]

{ #category : #actions }
SBGrammarHandler >> insertStatementAbove [
	<action>

	self insertStatementAboveOrBelow: true
]

{ #category : #'action helpers' }
SBGrammarHandler >> insertStatementAboveOrBelow: anAboveBoolean [

	| currentStatement index newStatement |
	newStatement := self block newNullBlock.
	currentStatement := self block containingStatement ifNil: [^ self block containingArtefact insertStatementAboveOrBelow: anAboveBoolean].
	
	(anAboveBoolean not and: [self block containingBlock = currentStatement or: [self block containingBlock hasOwner: currentStatement]]) ifTrue: [
		^ self block sandblockEditor
			do: ((SBInsertCommand newFor: self block containingArtefact)
				index: self block containingBlock statementsIndex;
				container: self block containingBlock;
				morph: newStatement;
				shouldMergeWithNext: true;
				yourself);
			startInput: newStatement at: 1 replacingContents: false].
	
	index := currentStatement owner submorphIndexOf: currentStatement.
	self block sandblockEditor
		do: ((SBInsertCommand newFor: self block containingArtefact)
			index: (anAboveBoolean ifTrue: [index] ifFalse: [index + 1]);
			container: currentStatement owner;
			morph: newStatement;
			shouldMergeWithNext: true;
			yourself);
		startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBGrammarHandler >> insertStatementBelow [
	<action>
	<actionValidIf: #hasNoSuggestions>

	self insertStatementAboveOrBelow: false
]

{ #category : #callbacks }
SBGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	^ self subclassResponsibility
]

{ #category : #'callback helpers' }
SBGrammarHandler >> replace: aBlock with: aMorph [

	self replace: aBlock with: aMorph mergeInput: true
]

{ #category : #'callback helpers' }
SBGrammarHandler >> replace: aBlock with: aMorph mergeInput: aBoolean [

	| wasInput |
	wasInput := aBlock sandblockEditor mode = #input.
	aBlock sandblockEditor cancelInput.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		shouldMergeWithNext: aBoolean;
		target: aBlock;
		replacer: aMorph).
	
	self focusNextFrom: aMorph at: 9e8 wasInput: wasInput
]

{ #category : #actions }
SBGrammarHandler >> selectStartOfStatement [
	<multiSelectAction>
	<inputAction>
	
	self block containingStatement firstDeepChild select.
	
	self block sandblockEditor maybeStartInputFromStart
]

{ #category : #'callback helpers' }
SBGrammarHandler >> tryDelete: aBlock [

	| editor p |
	p := aBlock previousBlock.
	editor := aBlock sandblockEditor.
	
	aBlock deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false
]

{ #category : #actions }
SBGrammarHandler >> unpackList [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	self block sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self block containingArtefact) target: self block)
]

{ #category : #'callback helpers' }
SBGrammarHandler >> wrap: aBlock do: aWrapBlock with: aNode [

	^ self wrap: aBlock do: aWrapBlock with: aNode focusOuter: false
]

{ #category : #'callback helpers' }
SBGrammarHandler >> wrap: aBlock do: aWrapBlock with: aNode focusOuter: aBoolean [

	| cursorIndex |
	cursorIndex := aBlock currentTextMorph ifNotNil: #cursor ifNil: [900000000].
	
	aBlock sandblockEditor
		endInput;
		do: ((SBWrapCommand newFor: aBlock containingArtefact)
			inner: aBlock;
			outer: aNode;
			shouldMergeWithNext: false;
			wrap: aWrapBlock).
	
	aBoolean
		ifTrue: [aNode sandblockEditor startInput: aNode at: 9e8 replacingContents: false]
		ifFalse: [self focusNextFrom: aNode at: cursorIndex]
]
