as yet unclassified
drawOn: aCanvas

	"aCanvas fillRectangle: self bounds color: self color."
	aCanvas frameAndFillRectangle: self bounds fillColor: self color borderWidth: 1 borderColor: (Color black alpha: 0.3).
	
	self prefix ifNotNil: [:p |
		self drawPrefix: p on: aCanvas]