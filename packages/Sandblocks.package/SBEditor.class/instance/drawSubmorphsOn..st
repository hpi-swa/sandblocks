drawing
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	self selection ifNotNil: [
		aCanvas frameRectangle: (self selection bounds expandBy: 2) width: 2 * self scalingFactor color: Color green]