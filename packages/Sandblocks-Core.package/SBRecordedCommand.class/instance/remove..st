action
remove: aMorph

	| index owner |
	owner := aMorph owner.
	index := aMorph submorphIndex.
	undo add: [owner addMorph: aMorph asElementNumber: index].
	
	aMorph delete.
	self removed: aMorph