as yet unclassified
acceptDroppingMorph: aMorph event: anEvent

	self allOwnersDo: #resetHighlightForDrop.
	self resetHighlightForDrop.
	self handleDroppedBlock: aMorph event: anEvent