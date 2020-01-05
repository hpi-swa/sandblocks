as yet unclassified
postDrawOn: aCanvas

	aCanvas
		frameRectangle: (self morph bounds expandBy: 2) width: self morph frameSize
		color: Color yellow