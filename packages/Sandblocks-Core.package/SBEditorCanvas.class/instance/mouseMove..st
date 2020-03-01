event handling
mouseMove: anEvent 
	dragging
		ifTrue: [| delta |
			delta := anEvent position - lastDragPosition.
			anEvent shiftPressed
				ifTrue: [self zoomViewport: delta y from: dragStartPosition]
				ifFalse: [self moveViewport: delta].
			lastDragPosition := anEvent position.
			dragLeftOverVelocity := delta]