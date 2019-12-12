as yet unclassified
openMethod: aMethodBlock

	self okToChange ifFalse: [^ self].
	
	self do: (SBInsertCommand newNonEdit
		index: 1;
		container: scroll;
		morph: (SBMethodContainer new method: aMethodBlock; fullBounds; yourself);
		yourself).
	
	"self resetState."
	
	^ aMethodBlock