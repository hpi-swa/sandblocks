as yet unclassified
replace: aBlock with: aMorph

	aBlock stopEditing.
	aBlock replaceBy: aMorph.
	
	aMorph moveCursorTo: 9e8.
	aMorph sandblockEditor replaceInput: aMorph