as yet unclassified
step
	
	self isDragging
		ifTrue: [^ self].
	self owner
		submorphsDo: [:morph | (morph ~= self
					and: [self bounds intersects: morph bounds])
				ifTrue: [| speed intersection direction maxSpeed |
					intersection := self bounds intersect: morph bounds.
					speed := intersection area.
					direction := Point
								fromSide: (morph bounds sideNearestTo: intersection center).
					velocity := velocity + (direction * 0.005 * speed).
					maxSpeed := 45.
					velocity := (velocity x clampLow: maxSpeed negated high: maxSpeed)
								@ (velocity y clampLow: maxSpeed negated high: maxSpeed)]].
	(velocity closeTo: 0 @ 0)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [velocity := velocity * 0.5.
			self position: self position + velocity]