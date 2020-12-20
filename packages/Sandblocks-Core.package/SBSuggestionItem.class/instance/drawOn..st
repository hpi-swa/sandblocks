as yet unclassified
drawOn: aCanvas

	| font foreground |
	active ifTrue: [aCanvas fillRectangle: self bounds color: self activeColor].
	
	font := self fontToUse.
	foreground := active ifTrue: [Color white] ifFalse: [Color black].
	
	aCanvas
		drawString: selector
		at: self layoutBounds origin
		font: font
		color: foreground.
	
	aCanvas
		drawString: label
		at: self layoutBounds topRight - ((font widthOfString: label) @ 0)
		font: font
		color: (foreground alpha: 0.5)