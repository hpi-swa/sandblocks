as yet unclassified
initialize
	super initialize.
	paintingForm := (Form extent: 100 asPoint depth: 32) "fillColor: Color white".
	stampForm := false
				ifTrue: [(Form fromFileNamed: '/home/tom/Pictures/brush.png')
						scaledIntoFormOfSize: 32 asPoint]
				ifFalse: [self createStampOfSize: 8 withScalingFactor].
	drawing := false.
	lastTouchPositions := Dictionary new.
	self extent: paintingForm extent