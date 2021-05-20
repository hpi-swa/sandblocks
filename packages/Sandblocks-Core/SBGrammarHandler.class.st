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

	Clipboard clipboardText: ((self block respondsTo: #prettySourceString) ifTrue: [self block prettySourceString] ifFalse: [self block sourceString])
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
	
	self block sandblockEditor isSingleArtefactView ifTrue: [^ result explore].
	
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

	| newStatement topMost offset body |
	" try to find a suitable place to insert a statement, either above or below the current statement,
	  or at the start of the containing block body, or at the start of first block body in the artefact "
	newStatement := self block newNullBlock.
	topMost := self block.
	[topMost parentSandblock notNil and: [topMost parentSandblock isBlockBody not]] whileTrue: [topMost := topMost parentSandblock].
	body := (topMost parentSandblock ifNil: [self block containingArtefact nextBlockThat: [:b | b isBlockBody]]) ifNil: [^ self].
	
	offset := (body statements indexOf: topMost ifAbsent: [0]) + (anAboveBoolean ifTrue: [-1] ifFalse: [0]) max: 0.
	
	self block sandblockEditor
		do: (SBInsertCommand new
			index: (body statements
				ifNotEmpty: [:s | s first submorphIndex + offset]
				ifEmpty: [body submorphCount + 1]);
			container: body;
			morph: newStatement;
			shouldMergeWithNext: true;
			yourself);
		startInput: newStatement at: 1 replacingContents: false
]

{ #category : #actions }
SBGrammarHandler >> insertStatementBelow [
	<action>

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
	aBlock sandblockEditor do: (SBReplaceCommand new
		shouldMergeWithNext: aBoolean;
		target: aBlock;
		replacer: aMorph).
	
	self focusNextFrom: aMorph at: 900000000 wasInput: wasInput
]

{ #category : #actions }
SBGrammarHandler >> selectStartOfStatement [
	<multiSelectAction>
	<inputAction>
	
	(self block containingStatement ifNil: [self block containingArtefact]) firstDeepChild select.
	
	self block sandblockEditor
		maybeStartInputFromStart;
		updateVerticalSelectionPosition
]

{ #category : #callbacks }
SBGrammarHandler >> startOverrideInput: anEvent in: anEditor [

	anEditor selection changeToUnknown.
	anEditor mode = #input ifTrue: [
		anEditor selection keyStroke: anEvent]
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

	self block sandblockEditor do: (SBUnwrapConsecutiveCommand new target: self block)
]

{ #category : #'action helpers' }
SBGrammarHandler >> watchWith: aWatchClass [

	self block isWatch ifTrue: [
		^ self block sandblockEditor do: (SBReplaceCommand new
			target: self block;
			replacer: self block childSandblocks first)].
	
	self block parentSandblock isWatch ifTrue: [^ self block deleteAround].
	
	self block sandblockEditor do: (SBWrapCommand new
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
		do: (SBWrapCommand new
			inner: aBlock;
			outer: aNode;
			shouldMergeWithNext: false;
			wrap: aWrapBlock).
	
	aBoolean
		ifTrue: [aNode sandblockEditor startInput: aNode at: 900000000 replacingContents: false]
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
