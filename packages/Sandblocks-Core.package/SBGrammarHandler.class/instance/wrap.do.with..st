as yet unclassified
wrap: aBlock do: aWrapBlock with: aNode

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