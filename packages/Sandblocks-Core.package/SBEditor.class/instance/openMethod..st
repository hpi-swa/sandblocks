as yet unclassified
openMethod: aMethodBlock

	| position |
	position := (self selection ifNotNil: #center ifNil: [0 @ 0]).
	self do: (SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (SBMethodContainer new method: aMethodBlock; fullBounds; yourself);
		yourself).
	
	"(self future: 300) refocus."
	
	aMethodBlock owner center: position.
	^ aMethodBlock