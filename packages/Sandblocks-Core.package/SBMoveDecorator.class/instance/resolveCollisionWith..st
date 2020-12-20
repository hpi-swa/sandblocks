as yet unclassified
resolveCollisionWith: otherMorph

	| intersection speed direction maxSpeed |
	intersection := self morph bounds intersect: otherMorph bounds.
	speed := intersection area.
	direction := Point fromSide: (otherMorph bounds sideNearestTo: intersection center).
	velocity := velocity + ((direction * 0.005) * speed).
	maxSpeed := 45.
	^ (velocity x clampLow: maxSpeed negated high: maxSpeed) @ (velocity y clampLow: maxSpeed negated high: maxSpeed)