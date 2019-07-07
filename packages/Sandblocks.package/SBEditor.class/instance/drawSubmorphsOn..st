drawing
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	self multiSelection do: [:morph |
		aCanvas frameRectangle: (morph bounds expandBy: 2) width: 3 * self scalingFactor color: ((morph parentSandblock ifNil: [morph]) foregroundColor alpha: 0.6)].
	
	self selection ifNotNil: [
		aCanvas frameRectangle: (self selection bounds expandBy: 2) width: 3 * self scalingFactor color: self selection foregroundColor].
	
	self unsavedChanges ifTrue: [ | adornment |
		adornment  := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas image: adornment at: self position + (self width - adornment width @ 0)]