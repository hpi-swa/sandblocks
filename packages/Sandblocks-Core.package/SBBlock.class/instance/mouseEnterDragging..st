as yet unclassified
mouseEnterDragging: anEvent

	self allOwnersDo: #resetHighlightForDrop.
	self highlightForDrop: true