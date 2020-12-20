event handling
mouseLeaveDragging: anEvent

	(anEvent hand firstSubmorph respondsTo: #noteDragLeave:) ifTrue: [anEvent hand firstSubmorph noteDragLeave: self].
	
	self highlightForDrop: false