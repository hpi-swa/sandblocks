as yet unclassified
replaceBy: aMorph

	super replaceBy: aMorph.
	currentCmd replacer: aMorph.
	currentCmd := nil.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph