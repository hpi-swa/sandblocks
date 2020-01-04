as yet unclassified
ensurePointReachable: aPoint

	| point |
	point := aPoint - self position.
	point x < stampForm width ifTrue: [self growBy: -1 @ 0].
	point y < stampForm height ifTrue: [self growBy: 0 @ -1].
	point x > (paintingForm width - stampForm width) ifTrue: [self growBy: 1 @ 0].
	point y > (paintingForm height - stampForm height) ifTrue: [self growBy: 0 @ 1]