event handling
mouseEnterDragging: anEvent

	(anEvent hand firstSubmorph respondsTo: #noteDragEnter:) ifTrue: [anEvent hand firstSubmorph noteDragEnter: self].
	
	self resetParentHighlights.
	self highlightForDrop: true