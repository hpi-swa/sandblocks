as yet unclassified
mouseUp: anEvent

	| strokes character |
	recording := false.
	
	points size = 1 ifTrue: [
		text := ''.
		self changed.
		^ self].
	
	" thin "
	points := Array streamContents: [:stream | | currentPoint |
		currentPoint := points first.
		stream nextPut: currentPoint.
		
		points allButFirstDo: [:point |
			(currentPoint squaredDistanceTo: point) > self smoothingThresholdSquared ifTrue: [
				currentPoint := point.
				stream nextPut: currentPoint]]].
	
	" isolate directions "
	strokes := Array streamContents: [:stream | | currentDirection |
		currentDirection := nil.
		points overlappingPairsDo: [:from :to | | direction |
			direction := self directionFrom: from to: to.
			direction = currentDirection ifFalse: [
				stream nextPut: direction.
				currentDirection := direction]]].
	
	
	character := self characterFromStrokes: strokes points: points.
	character ifNotNil: [
		character = Character backspace ifTrue: [text := text allButLast] ifFalse: [text := text, character]].
	self changed