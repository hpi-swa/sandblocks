as yet unclassified
startDrag: anEvent

	"dragging := true.
	lastDragPosition := anEvent position.
	dragStartPosition := anEvent position"
	| canvas |
	canvas := SBDrawCanvas new center: (self transform globalPointToLocal: anEvent position).
	self addMorphBack: canvas.
	canvas mouseDown: (anEvent transformedBy: self transform).
	anEvent hand newMouseFocus: canvas