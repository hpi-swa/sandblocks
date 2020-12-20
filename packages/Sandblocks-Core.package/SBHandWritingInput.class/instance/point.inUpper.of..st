as yet unclassified
point: aPoint inUpper: aNumber of: aCollection

	| rangeY refY |
	rangeY := aCollection inject: (9e8 to: 0) into: [:interval :point | | ret |
		ret := interval.
		point y < ret start ifTrue: [ret := point y to: ret stop].
		point y > ret stop ifTrue: [ret := ret start to: point y].
		ret].
	
	refY := aPoint y - rangeY start.
	^ (refY / rangeY extent) < aNumber