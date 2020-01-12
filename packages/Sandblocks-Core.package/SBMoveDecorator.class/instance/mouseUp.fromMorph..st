event handling
mouseUp: anEvent fromMorph: aMorph

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]