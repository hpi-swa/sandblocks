Class {
	#name : #SBHandWritingInput,
	#superclass : #Morph,
	#instVars : [
		'points',
		'recording',
		'text'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHandWritingInput >> characterFromStrokes: aCollection points: aPointCollection [

	| seq |
	seq := aCollection collect: #first as: String.
	
	(seq matchesRegex: 'r') ifTrue: [^ Character space].
	(seq matchesRegex: 'l') ifTrue: [^ Character backspace].
	
	(seq matchesRegex: 'ur?dl?r?') ifTrue: [^ $A].
	(seq matchesRegex: 'durdl?rd?l') ifTrue: [^ $B].
	(seq matchesRegex: 'u?ldru?') ifTrue: [^ $C].
	(seq matchesRegex: 'dur?dl') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.7 of: aPointCollection) ifTrue: [$P] ifFalse: [$D]].
	(seq matchesRegex: 'ld?r?l?d?r') ifTrue: [^ $E].
	(seq matchesRegex: 'lr?d') ifTrue: [^ $F].
	(seq matchesRegex: 'l?drul?rd?') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.2 of: aPointCollection) ifTrue: [$Q] ifFalse: [$G]].
	(seq matchesRegex: 'dr?u?r?d') ifTrue: [^ $H].
	(seq matchesRegex: 'd') ifTrue: [^ $I].
	(seq matchesRegex: 'dl') ifTrue: [^ $J].
	(seq matchesRegex: 'l?dlurdr?') ifTrue: [^ $K].
	(seq matchesRegex: 'dr') ifTrue: [
		^ (aPointCollection last y > (self height * 0.6)) ifTrue: [$L] ifFalse: [$4]]. " potentially wonky, maybe relative? "
	(seq matchesRegex: 'ur?dr?u?r?d') ifTrue: [^ $M].
	(seq matchesRegex: 'ur?dr?u') ifTrue: [^ $N].
	(seq matchesRegex: 'l?drul') ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.3 of: aPointCollection) ifTrue: [$O] ifFalse: [$6]].
	(seq matchesRegex: 'dur?dl?d?r?') ifTrue: [^ $R].
	" disambiguate against 8 by checking that we ended in a low area "
	((seq matchesRegex: 'ld?r?d?lu?r?') and: [(self point: aPointCollection last inUpper: 0.3 of: aPointCollection) not]) ifTrue: [^ $S].
	(seq matchesRegex: 'rd') ifTrue: [
		^ (self point: aPointCollection last inLeft: 0.6 of: aPointCollection) ifTrue: [$7] ifFalse: [$T]].
	(seq matchesRegex: 'drud?') ifTrue: [^ $U].
	(seq matchesRegex: 'dur?') ifTrue: [^ $V].
	(seq matchesRegex: 'dr?u?dr?u') ifTrue: [^ $W].
	(seq matchesRegex: 'dlur?') ifTrue: [^ $X].
	(seq matchesRegex: 'dru?d?l?ur?') ifTrue: [^ $Y].
	(seq matchesRegex: 'rl?dl?d?r') ifTrue: [^ $Z].
	
	(seq matchesRegex: 'rdlur') ifTrue: [^ $0].
	(seq matchesRegex: 'u') ifTrue: [^ $1].
	(seq matchesRegex: 'urdl?d?r') ifTrue: [^ $2].
	(seq matchesRegex: 'u?rdl?d?rdlu?') ifTrue: [^ $3].
	(seq matchesRegex: 'drdlu?') ifTrue: [^ $5].
	(seq matchesRegex: 'u?l?dr?d?lur?u?l?') ifTrue: [^ $8].
	(seq matchesRegex: 'ldrudl?u?r?') ifTrue: [^ $9].
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> directionFrom: aPoint to: anotherPoint [

	| delta |
	delta := (aPoint - anotherPoint) abs.
	
	^ delta x > delta y
		ifTrue: [aPoint x > anotherPoint x ifTrue: [#left] ifFalse: [#right]]
		ifFalse: [aPoint y > anotherPoint y ifTrue: [#up] ifFalse: [#down]]
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> drawOn: aCanvas [

	| cursorStart font |
	font := TextStyle defaultFont.
	
	aCanvas fillRectangle: self bounds color: Color white.
	aCanvas drawString: text at: self topLeft + 4 font: font color: Color black.
	
	cursorStart := (font widthOfString: text) @ self top + (self left + 4 @ 4).
	aCanvas line: cursorStart to: cursorStart + (0 @ font height) width: 2 color: Color red.
	
	points overlappingPairsDo: [:start :end | | direction |
		direction := self directionFrom: start to: end.
		aCanvas fillOval: ((6 asPoint center: start) translateBy: self position) color: Color red.
		aCanvas line: start + self position to: end + self position width: 2 color: (direction caseOf: {
			[#left] -> [Color red].
			[#right] -> [Color green].
			[#up] -> [Color blue].
			[#down] -> [Color lightGray].
		})]
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> handlesMouseMove: anEvent [

	^ true
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> initialize [

	super initialize.
	
	recording := false.
	points := OrderedCollection new.
	text := ''.
	
	self extent: TextStyle defaultFont height asPoint * (40 @ 16)
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> mouseDown: anEvent [

	recording := true.
	points := OrderedCollection new.
	points add: anEvent position - self position.
	self changed
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> mouseMove: anEvent [

	recording ifFalse: [^ false].
	
	points add: anEvent position - self position.
	self changed
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> mouseUp: anEvent [

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
		character = Character backspace ifTrue: [text := text ifNotEmpty: #allButLast] ifFalse: [text := text, character]].
	self changed
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> oldCharacterFromStrokes: aCollection points: aPointCollection [

	aCollection = #(right) ifTrue: [^ Character space].
	aCollection = #(left) ifTrue: [^ Character backspace].
	
	aCollection = #(up down) ifTrue: [^ $A].
	aCollection = #(down up right down left right down left) ifTrue: [^ $B].
	aCollection = #(left down right) ifTrue: [^ $C].
	aCollection = #(down up right down left) ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.7 of: aPointCollection) ifTrue: [$P] ifFalse: [$D]].
	aCollection = #(left down right left down right) ifTrue: [^ $E].
	aCollection = #(left down) ifTrue: [^ $F].
	aCollection = #(left down right up left right) ifTrue: [
		^ (self point: aPointCollection last inUpper: 0.1 of: aPointCollection) ifTrue: [$Q] ifFalse: [$G]].
	aCollection = #(down up right down) ifTrue: [^ $H].
	aCollection = #(down) ifTrue: [^ $I].
	aCollection = #(down left) ifTrue: [^ $J].
	aCollection = #(down left up right down) ifTrue: [^ $K].
	aCollection = #(down right) ifTrue: [
		^ (aPointCollection last y > (self height * 0.6)) ifTrue: [$L] ifFalse: [$4]]. " potentially wonky, maybe relative? "
	aCollection = #(up right down up right down) ifTrue: [^ $M].
	aCollection = #(up right down right up) ifTrue: [^ $N].
	aCollection = #(left down right up left) ifTrue: [^ $O].
	aCollection = #(down up right down left down) ifTrue: [^ $R].
	aCollection = #(left down right down left) ifTrue: [^ $S].
	aCollection = #(right down) ifTrue: [
		^ (self point: aPointCollection last inLeft: 0.7 of: aPointCollection) ifTrue: [$7] ifFalse: [$T]].
	aCollection = #(down right up) ifTrue: [^ $U].
	aCollection = #(down up right) ifTrue: [^ $V].
	aCollection = #(down up down up) ifTrue: [^ $W].
	aCollection = #(down left up) ifTrue: [^ $X].
	aCollection = #(down right up down left up right) ifTrue: [^ $Y].
	aCollection = #(right down right) ifTrue: [^ $Z]. "wonky"
	
	aCollection = #(right down left up right) ifTrue: [^ $0].
	aCollection = #(up) ifTrue: [^ $1].
	aCollection = #(up right down right) ifTrue: [^ $2].
	aCollection = #(right down left right down left) ifTrue: [^ $3].
	aCollection = #(left down right down left up) ifTrue: [^ $5].
	aCollection = #(left down right up left) ifTrue: [^ $6].
	aCollection = #(left down right down left up right up) ifTrue: [^ $8].
	aCollection = #(left down right up down) ifTrue: [^ $9].
	
	^ nil
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> point: aPoint inLeft: aNumber of: aCollection [

	| rangeX refX |
	rangeX := aCollection inject: (9e8 to: 0) into: [:interval :point | | ret |
		ret := interval.
		point x < ret start ifTrue: [ret := point x to: ret stop].
		point x > ret stop ifTrue: [ret := ret start to: point x].
		ret].
	
	refX := aPoint x - rangeX start.
	^ (refX / rangeX extent) < aNumber
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> point: aPoint inUpper: aNumber of: aCollection [

	| rangeY refY |
	rangeY := aCollection inject: (9e8 to: 0) into: [:interval :point | | ret |
		ret := interval.
		point y < ret start ifTrue: [ret := point y to: ret stop].
		point y > ret stop ifTrue: [ret := ret start to: point y].
		ret].
	
	refY := aPoint y - rangeY start.
	^ (refY / rangeY extent) < aNumber
]

{ #category : #'as yet unclassified' }
SBHandWritingInput >> smoothingThresholdSquared [

	^ 200
]
