actions
addToMultiSelection

	multiSelection copy do: [:morph | (morph hasOwner: self selection) ifTrue: [multiSelection remove: morph]].
	
	multiSelection add: self selection.
	self changed.
	self updateSelectionLabel