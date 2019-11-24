as yet unclassified
drawFrame: aColor on: aCanvas

	aCanvas
		frameRectangle: (self bounds expandBy: 2) width: 3 * self scalingFactor
		color: aColor