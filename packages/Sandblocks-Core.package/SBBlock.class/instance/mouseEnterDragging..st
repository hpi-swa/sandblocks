event handling
mouseEnterDragging: anEvent

	self allOwnersDo: #resetHighlightForDrop.
	self highlightForDrop: true