as yet unclassified
drawArrowOn: aCanvas origin: aPoint delta: anotherPoint

	aCanvas line: aPoint to: aPoint + anotherPoint width: 3 color: self color.
	aCanvas line: aPoint to: aPoint + anotherPoint leftRotated width: 3 color: self color