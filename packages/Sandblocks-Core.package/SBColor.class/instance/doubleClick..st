as yet unclassified
doubleClick: anEvent

	self flag: #todo. " we dont know when we're closed so we can't create a proper command for undo "
	(NewColorPickerMorph on: self originalColor: indicator color setColorSelector: #colorContentsUpdate:) openNear: self