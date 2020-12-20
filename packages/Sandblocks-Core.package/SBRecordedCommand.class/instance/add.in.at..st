action
add: aMorph in: anOwnerMorph at: aNumber

	undo add: [aMorph delete].
	anOwnerMorph addMorph: aMorph asElementNumber: aNumber.
	self added: aMorph