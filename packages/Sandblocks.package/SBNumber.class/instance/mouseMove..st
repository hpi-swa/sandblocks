as yet unclassified
mouseMove: anEvent

	| delta |
	isDown ifTrue: [
		delta := anEvent position - lastMousePosition.
		self flag: #todo. "preserve formatting like base"
		self contents: (self parsedContents + delta x) asString.
		lastMousePosition := anEvent position.
		self sandblockEditor batchedChangeStep]