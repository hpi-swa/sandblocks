event handling
mouseMove: anEvent

	lastDragPosition ifNotNil: [
		self position: self position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position]