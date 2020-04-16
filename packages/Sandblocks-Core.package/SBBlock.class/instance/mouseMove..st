as yet unclassified
mouseMove: anEvent

	super mouseMove: anEvent.
	(anEvent isDraggingEvent and: [self handlesMouseOverDragging: anEvent]) ifTrue: [self highlightForDrop]