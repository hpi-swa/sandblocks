drawing
drawSubmorphsOn: aCanvas

	super drawSubmorphsOn: aCanvas.
	
	self unsavedChanges ifTrue: [ | adornment |
		adornment  := PluggableTextMorph adornmentWithColor: Color orange.
		aCanvas image: adornment at: self position + (self width - adornment width @ 0)]