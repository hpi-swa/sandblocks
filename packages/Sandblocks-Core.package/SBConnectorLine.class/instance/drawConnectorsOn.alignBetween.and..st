as yet unclassified
drawConnectorsOn: aCanvas alignBetween: aPoint and: anotherPoint

	| rotated |
	self connectorType = #arrow ifTrue: [
		rotated := Point r: self arrowSize degrees: (aPoint - anotherPoint) theta radiansToDegrees + 45.
		self drawArrowOn: aCanvas origin: anotherPoint delta: rotated].
	self connectorType = #dots ifTrue: [{aPoint. anotherPoint} do: [:point | aCanvas fillOval: (14 asPoint center: point) color: self color]]