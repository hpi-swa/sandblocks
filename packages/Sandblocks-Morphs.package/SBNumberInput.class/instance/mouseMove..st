event handling
mouseMove: anEvent

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self valueWithConstraints: self value + delta x.
		lastMousePosition := anEvent position.
		self sendChange]