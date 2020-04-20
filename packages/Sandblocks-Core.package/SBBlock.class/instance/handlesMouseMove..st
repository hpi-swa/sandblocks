event handling
handlesMouseMove: anEvent

	^ (super handlesMouseMove: anEvent) or: [anEvent isDraggingEvent]