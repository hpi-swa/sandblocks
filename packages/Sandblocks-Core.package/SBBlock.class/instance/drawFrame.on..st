as yet unclassified
drawFrame: aColor on: aCanvas

	aCanvas
		frameRectangle: (self bounds expandBy: 2) width: self frameSize
		color: aColor