drawing
drawOn: aCanvas

	aCanvas fillRoundRect: self bounds radius: 4 withScalingFactor fillStyle: Color darkGray.
	super drawOn: aCanvas