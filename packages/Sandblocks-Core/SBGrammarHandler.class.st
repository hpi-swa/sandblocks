Class {
	#name : #SBGrammarHandler,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #helper }
SBGrammarHandler class >> eventValidForString: anEvent [

	(anEvent commandKeyPressed or: [anEvent optionKeyPressed or: [anEvent controlKeyPressed]]) ifTrue: [^ false].
	
	^ anEvent keyCharacter isPrintable
]

{ #category : #'action helpers' }
SBGrammarHandler >> block [

	^ currentBlock
]

{ #category : #'action helpers' }
SBGrammarHandler >> block: aBlock [

	currentBlock := aBlock
]

{ #category : #testing }
SBGrammarHandler >> characterCanStartInput: aCharacter [
	" Return true if this character can be a valid start of an expression.
	  If so, pressing this character on a selection will replace the selection by a new unknown that
	  is input this character. "
	
	^ aCharacter isAlphaNumeric
]

{ #category : #actions }
SBGrammarHandler >> copyString [
	<action>

	Clipboard clipboardText: self block prettySourceString
]

{ #category : #actions }
SBGrammarHandler >> doExpression [
	<action>

	^ SBExecutionEnvironment value: self block containingArtefact during: [self block evaluate]
]

{ #category : #actions }
SBGrammarHandler >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>

	| result |
	result := SBExecutionEnvironment value: self block containingArtefact during: [self block evaluate].
	
	result convertedFor: SBInterfaces topLevel doWithChooser: [:morph |
		self block sandblockEditor openMorphInView: morph.
		morph focusAfterDelete: self block.
		self block sandblockEditor connectFrom: self block to: morph.
		morph].
	^ result
]

{ #category : #'callback helpers' }
SBGrammarHandler >> focusNextFrom: aMorph at: aNumber [

	self focusNextFrom: aMorph at: aNumber wasInput: aMorph sandblockEditor mode = #input
]

{ #category : #'callback helpers' }
SBGrammarHandler >> focusNextFrom: aMorph at: aNumber wasInput: aBoolean [

	aMorph sandblockEditor
		endInput;
		startInput: aMorph at: 900000000 replacingContents: false.
	
	aMorph sandblockEditor mode = #input ifFalse: [aMorph inputContainedUnknown]
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

{ #category : #'block creation' }
SBGrammarHandler >> newCommentBlock [

	^ self subclassResponsibility
]

{ #category : #'block creation' }
SBGrammarHandler >> newNullBlock [

	^ SBUnknown new grammarHandler: self
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
	
	self block sandblockEditor
		maybeStartInputFromStart;
		updateVerticalSelectionPosition
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
SBGrammarHandler >> unwrapList [
	<action>
	<actionValidIf: #parentHasDynamicNumberOfChildren>

	self block sandblockEditor do: ((SBUnwrapConsecutiveCommand newFor: self block containingArtefact) target: self block)
]

{ #category : #'action helpers' }
SBGrammarHandler >> watchWith: aWatchClass [

	self block isWatch
		ifTrue: [^ self block sandblockEditor do: ((SBReplaceCommand newFor: self block containingArtefact) target: self block; replacer: self block childSandblocks first)].
	
	self block parentSandblock isWatch ifTrue: [^ self block deleteAround].
	
	self block sandblockEditor do: ((SBWrapCommand newFor: self block containingArtefact)
			outer: aWatchClass new newIdentifier;
			inner: self block;
			wrap: [:outer :inner | outer expression: inner])
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

{ #category : #actions }
SBGrammarHandler >> wrapWithWatch [
	<action>
	<inputAction>
	<actionValidIf: #isExpression>

	self watchWith: SBWatch
]

{ #category : #printing }
SBGrammarHandler >> writeSourceOn: aStream for: aBlock [

	self subclassResponsibility
]
