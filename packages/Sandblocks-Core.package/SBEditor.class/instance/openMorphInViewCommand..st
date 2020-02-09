submorphs-add/remove
openMorphInViewCommand: aMorph

	| position |
	position := (self selection ifNotNil: #center ifNil: [0 @ 0]).
	^ SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph center: position; fullBounds; yourself);
		yourself