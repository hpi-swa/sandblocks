as yet unclassified
doReplaceBy: aMorph

	self stopEditing.
	self replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph