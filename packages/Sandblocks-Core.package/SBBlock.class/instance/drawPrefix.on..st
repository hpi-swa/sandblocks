as yet unclassified
drawPrefix: aString on: aCanvas

	| font width fg |
	font := self fontToUse.
	width := font widthOfString: aString.
	fg := self sandblockForegroundColor.
	aCanvas
		drawString: aString
		at: self layoutBounds origin + (self spaceForPrefix negated + ((self spaceForPrefix / 2) - (width / 2)) rounded @ ((self layoutBounds height / 2) - (font height / 2)) rounded)
		font: font
		color: (fg = Color white ifTrue: [Color veryLightGray] ifFalse: [fg alpha: 0.5])