Class {
	#name : #SBGrammarHandler,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGrammarHandler >> perform: char for: aBlock empty: aBoolean [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBGrammarHandler >> replace: aBlock with: aMorph [

	aBlock stopEditing.
	aBlock replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph
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
