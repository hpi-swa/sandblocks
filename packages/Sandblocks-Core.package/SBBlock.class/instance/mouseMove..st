as yet unclassified
mouseMove: anEvent

	super mouseMove: anEvent.
	(anEvent isDraggingEvent and: [anEvent hand hasSubmorphs]) ifTrue: [self highlightForDrop]