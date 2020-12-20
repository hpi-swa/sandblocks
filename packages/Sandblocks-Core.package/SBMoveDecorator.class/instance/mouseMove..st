event handling
mouseMove: anEvent

	lastDragPosition ifNotNil: [
		self morph position: self morph position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position]