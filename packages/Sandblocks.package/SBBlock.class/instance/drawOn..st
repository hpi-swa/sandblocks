as yet unclassified
drawOn: aCanvas

	"aCanvas fillRectangle: self bounds color: self color."
	aCanvas
		frameAndFillRectangle: self bounds
		fillColor: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self) 
		borderColor: (self colorPolicy borderColorForBlock: self).
	
	self prefix ifNotNil: [:p |
		self drawPrefix: p on: aCanvas]