as yet unclassified
drawOn: aCanvas

	aCanvas fillRectangle: self bounds color: self color.
	
	self valid
		ifFalse: [aCanvas frameRectangle: self bounds width: 4 color: Color red].
	
	self isSelected
		ifTrue: [aCanvas frameRectangle: self bounds color: Color white].
	
	self prefix ifNotNil: [:p |
		self drawPrefix: p on: aCanvas]