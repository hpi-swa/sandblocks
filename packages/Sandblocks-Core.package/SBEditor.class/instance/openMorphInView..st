submorphs-add/remove
openMorphInView: aMorph

	self do: (SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph fullBounds; yourself);
		yourself).
	
	^ aMorph