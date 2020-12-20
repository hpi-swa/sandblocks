as yet unclassified
resolveCollisionCenteredWith: otherMorph

	| intersection speed direction speedFactor |
	intersection := self morph bounds intersect: otherMorph bounds.
	speed := intersection area.
	direction := (self morph center = otherMorph center
		ifTrue: [ThreadSafeRandom next @ ThreadSafeRandom next]
		ifFalse: [self morph center - otherMorph center]) normalized.
	speedFactor := 0.005.
	^ direction * (speedFactor * intersection area)