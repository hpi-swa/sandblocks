as yet unclassified
mouseMove: anEvent

	drawing
		ifTrue: [
			self fillFrom: lastMousePosition to: anEvent position.
			lastMousePosition := anEvent position]