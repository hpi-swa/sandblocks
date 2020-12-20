as yet unclassified
drawOn: aCanvas

	aCanvas frameAndFillRectangle: self bounds fillColor: self backgroundColor borderWidth: 2 borderColor: Color black.
	aCanvas drawString: self contents in: self layoutBounds font: nil color: (active ifTrue: [Color white] ifFalse: [Color black])