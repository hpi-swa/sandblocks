event handling
mouseMove: anEvent fromMorph: aMorph

	lastDragPosition ifNotNil: [
		aMorph position: aMorph position + (anEvent position - lastDragPosition).
		lastDragPosition := anEvent position]