event handling
mouseUp: anEvent

	lastDragPosition ifNotNil: [
		anEvent hand releaseMouseFocus: self.
		lastDragPosition := nil]