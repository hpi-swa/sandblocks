as yet unclassified
acceptDroppingMorph: aMorph event: anEvent

	self sandblockEditor containingWindow ifNotNil: #beKeyWindow.
	self allOwnersDo: #resetHighlightForDrop.
	self resetHighlightForDrop.
	self handleDroppedBlock: aMorph event: anEvent