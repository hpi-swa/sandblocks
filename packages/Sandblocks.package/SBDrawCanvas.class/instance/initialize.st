as yet unclassified
initialize
	super initialize.
	paintingForm := (Form extent: 400 asPoint depth: 32)
				fill: (0 @ 0 extent: 400 asPoint)
				rule: Form over
				fillColor: Color white.
	stampForm := true
				ifTrue: [(Form fromFileNamed: '/home/tom/Pictures/brush.png')
						scaledIntoFormOfSize: 32 asPoint]
				ifFalse: [self createStampOfSize: 32].
	drawing := false.
	lastTouchPositions := Dictionary new.
	self extent: paintingForm extent