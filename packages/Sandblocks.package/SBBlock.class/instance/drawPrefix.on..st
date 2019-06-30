as yet unclassified
drawPrefix: aString on: aCanvas

	| font width |
	font := TextStyle defaultFont.
	width := font widthOfString: aString.
	aCanvas
		drawString: aString
		at: self layoutBounds origin + (self spaceForPrefix negated + ((self spaceForPrefix / 2) - (width / 2)) rounded @ ((self layoutBounds height / 2) - (font height / 2)) rounded)
		font: font
		color: (self sandblockForegroundColor alpha: 0.5)