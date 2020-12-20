as yet unclassified
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	self valid ifFalse: [aCanvas frameRectangle: self bounds width: 2 * self scalingFactor color: Color red].
	
	self decorators do: [:d | d postDrawOn: aCanvas]