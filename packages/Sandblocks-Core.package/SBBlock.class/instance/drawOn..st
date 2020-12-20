as yet unclassified
drawOn: aCanvas

	self decorators do: [:d | d preDrawOn: aCanvas].
	
	aCanvas
		frameAndFillRectangle: self bounds
		fillColor: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self) 
		borderColor: (self colorPolicy borderColorForBlock: self).
	
	self drawSymbolsOn: aCanvas