as yet unclassified
extent: aPoint

	super extent: aPoint.
	
	data size ~= aPoint x ifTrue: [
		data size: aPoint x // self gap]