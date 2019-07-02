as yet unclassified
drawOn: aCanvas

	aCanvas fillRectangle: self bounds color: self color.
	
	"self isSelected
		ifTrue: [aCanvas frameRectangle: self bounds width: self scalingFactor color: Color white]."
	
	self prefix ifNotNil: [:p |
		self drawPrefix: p on: aCanvas]