as yet unclassified
drawOn: aCanvas

	aCanvas fillRoundRect: self bounds radius: 4 fillStyle: Color veryDarkGray.
	
	self isSelected ifTrue: [
		aCanvas frameRoundRect: self bounds radius: 4 width: 1 color: Color white]