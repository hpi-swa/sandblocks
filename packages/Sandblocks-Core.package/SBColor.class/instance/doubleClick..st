as yet unclassified
doubleClick: anEvent

	previousColor := self colorContents.
	
	(NewColorPickerMorph on: self originalColor: indicator color setColorSelector: #colorContentsUpdate:)
		openNear: self;
		when: #closed send: #saveColor to: self