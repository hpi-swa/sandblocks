as yet unclassified
extent: aPoint

	| point |
	point := aPoint max: 10 @ 30.
	super extent: point.
	data size ~= point x ifTrue: [data size: point x // self gap]