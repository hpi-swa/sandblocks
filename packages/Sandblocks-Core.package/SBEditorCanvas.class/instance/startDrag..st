event handling
startDrag: anEvent

	| canvas |
	anEvent redButtonPressed
		ifTrue: [
			canvas := SBDrawCanvas new center: (self transform globalPointToLocal: anEvent position).
			self addMorphBack: canvas.
			canvas mouseDown: (anEvent transformedBy: self transform).
			anEvent hand newMouseFocus: canvas]
		ifFalse: [
			dragging := true.
			lastDragPosition := anEvent position.
			dragStartPosition := anEvent position]