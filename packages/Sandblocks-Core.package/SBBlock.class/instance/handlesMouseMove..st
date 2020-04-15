as yet unclassified
handlesMouseMove: anEvent

	^ (super handlesMouseMove: anEvent) or: [anEvent isDraggingEvent]