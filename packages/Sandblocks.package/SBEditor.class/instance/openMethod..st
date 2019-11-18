as yet unclassified
openMethod: aMethodBlock

	self okToChange ifFalse: [^ self].
	
	scroll addMorphBack: (SBMethodContainer new position: self position; editor: self; method: aMethodBlock).
	self resetState.
	self changed: #relabel.
	
	self resizeToFit