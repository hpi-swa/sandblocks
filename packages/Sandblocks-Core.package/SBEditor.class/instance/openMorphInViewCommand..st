submorphs-add/remove
openMorphInViewCommand: aMorph

	| position |
	position := (self selection ifNotNil: #bottomLeft ifNil: [scroll offset + (self extent // 2)]).
	^ SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph topLeft: position; fullBounds; yourself);
		yourself