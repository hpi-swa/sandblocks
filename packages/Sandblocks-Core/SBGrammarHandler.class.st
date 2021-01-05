Class {
	#name : #SBGrammarHandler,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGrammarHandler >> focusNextFrom: aMorph at: aNumber [

	self focusNextFrom: aMorph at: aNumber wasInput: aMorph sandblockEditor mode = #input
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarHandler >> replace: aBlock with: aMorph [

	| wasInput |
	wasInput := aBlock sandblockEditor mode = #input.
	aBlock sandblockEditor cancelInput.
	aBlock sandblockEditor do: ((SBReplaceCommand newFor: aBlock containingArtefact)
		"shouldMergeWithNext: true;"
		target: aBlock;
		replacer: aMorph).
	"aBlock replaceBy: aMorph."
	
	self focusNextFrom: aMorph at: 9e8 wasInput: wasInput
]

{ #category : #'as yet unclassified' }
SBGrammarHandler >> tryDelete: aBlock [

	| editor p |
	p := aBlock previousBlock.
	editor := aBlock sandblockEditor.
	
	aBlock deleteBlock.
	editor startInput: p at: 9e8 replacingContents: false
]

{ #category : #'as yet unclassified' }
SBGrammarHandler >> wrap: aBlock do: aWrapBlock with: aNode [

	^ self wrap: aBlock do: aWrapBlock with: aNode focusOuter: false
]

{ #category : #'as yet unclassified' }
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
