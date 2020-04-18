submorphs-add/remove
openMorphInViewCommand: aMorph

	| position |
	position := (self selection ifNotNil: #center ifNil: [scroll offset + (self extent // 2)]).
	^ SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph center: position; fullBounds; yourself);
		yourself