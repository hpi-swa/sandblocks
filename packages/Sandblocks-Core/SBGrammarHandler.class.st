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

{ #category : #actions }
SBGrammarHandler >> copyString [
	<action>

	Clipboard clipboardText: self block prettySourceString
]

{ #category : #actions }
SBGrammarHandler >> evaluateExpression [
	<action>
	<actionValidIf: #isExpression>

	| result |
	result := self block evaluate.
	result convertedFor: SBInterfaces topLevel do: [:morph |
		self block sandblockEditor openMorphInView: morph.
		morph focusAfterDelete: self block.
		self block sandblockEditor connectFrom: self block to: morph].
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

{ #category : #printing }
SBGrammarHandler >> writeSourceOn: aStream for: aBlock [

	self subclassResponsibility
]
