as yet unclassified
directionFrom: aPoint to: anotherPoint

	| delta |
	delta := (aPoint - anotherPoint) abs.
	
	^ delta x > delta y
		ifTrue: [aPoint x > anotherPoint x ifTrue: [#left] ifFalse: [#right]]
		ifFalse: [aPoint y > anotherPoint y ifTrue: [#up] ifFalse: [#down]]