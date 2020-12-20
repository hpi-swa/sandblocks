as yet unclassified
drawArrowOn: aCanvas origin: aPoint delta: anotherPoint

	aCanvas asBalloonCanvas
		aaLevel: 4;
		line: aPoint to: aPoint + anotherPoint width: 3 color: self color;
		line: aPoint to: aPoint + anotherPoint leftRotated width: 3 color: self color