as yet unclassified
drawOn: aCanvas

	active ifTrue: [aCanvas fillRectangle: self bounds color: self activeColor].
	aCanvas
		drawString: selector
		at: self layoutBounds origin
		font: self fontToUse
		color: (active ifTrue: [Color white] ifFalse: [Color black])