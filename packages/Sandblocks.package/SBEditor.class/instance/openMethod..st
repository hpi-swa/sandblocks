as yet unclassified
openMethod: aMethodBlock

	self okToChange ifFalse: [^ self].
	
	self do: (SBInsertCommand new
		wasEdit: true;
		index: 1;
		container: scroll;
		morph: (SBMethodContainer new position: self position; method: aMethodBlock);
		yourself).
	self resetState.
	self changed: #relabel.
	
	"self resizeToFit."
	
	^ aMethodBlock