submorphs-add/remove
openMorphInView: aMorph

	| position |
	position := (self selection ifNotNil: #center ifNil: [0 @ 0]).
	self do: (SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (aMorph fullBounds; yourself);
		yourself).
	
	"(self future: 300) refocus."
	
	aMorph owner center: position.
	^ aMorph