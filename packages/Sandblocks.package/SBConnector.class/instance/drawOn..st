as yet unclassified
drawOn: aCanvas

	"aCanvas line: source center to: destination center width: 2 * self scalingFactor color: Color black"
	aCanvas asBalloonCanvas
		drawBezier3Shape: {
			source center.
			source center + (destination left - source left * 0.5 @ 0).
			destination center - (destination left - source left * 0.5 @ 0).
			destination center}
		color: Color transparent
		borderWidth: 2 * self scalingFactor
		borderColor: Color black