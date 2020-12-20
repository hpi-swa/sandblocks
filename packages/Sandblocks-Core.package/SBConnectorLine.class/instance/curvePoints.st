as yet unclassified
curvePoints

	self isSelfConnection ifTrue: [^ self curvePointsForSelfConnection].
	self evade ~= #none ifTrue: [^ self curvePointsForEvade].
	^ self endPointsDo: [:a :b | | delta controlSize controlPoint fromControl toControl |
		delta := a - b.
		controlSize := (delta x max: delta y) / 2.
		controlPoint := delta x abs > delta y abs ifTrue: [controlSize @ 0] ifFalse: [0 @ controlSize].
		fromControl := fromAlign = #none ifTrue: [controlPoint * delta sign negated] ifFalse: [(Point fromSide: fromAlign) * self controlSize].
		toControl := toAlign = #none ifTrue: [controlPoint * delta sign] ifFalse: [(Point fromSide: toAlign) * self controlSize].
		{a. (a + fromControl). (b + toControl). b}]