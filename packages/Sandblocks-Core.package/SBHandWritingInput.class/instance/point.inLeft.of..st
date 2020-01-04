as yet unclassified
point: aPoint inLeft: aNumber of: aCollection

	| rangeX refX |
	rangeX := aCollection inject: (9e8 to: 0) into: [:interval :point | | ret |
		ret := interval.
		point x < ret start ifTrue: [ret := point x to: ret stop].
		point x > ret stop ifTrue: [ret := ret start to: point x].
		ret].
	
	refX := aPoint x - rangeX start.
	^ (refX / rangeX extent) < aNumber