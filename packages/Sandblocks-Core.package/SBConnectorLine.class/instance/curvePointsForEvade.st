as yet unclassified
curvePointsForEvade

	| delta controlDistance angle |
	^ self endPointsDo: [:a :b |
		delta := a - b.
		controlDistance := (self width max: self height) / 4.
		angle := (evade = #left ifTrue: [45] ifFalse: [-45]) degreesToRadians.
		{
			a.
			a + (delta normalized negated * controlDistance rotatedBy: angle negated).
			b + (delta normalized * controlDistance rotatedBy: angle).
			b
		}]