stepping
step

	| hadIntersect |
	hadIntersect := false.
	self isDragging ifTrue: [^ self].
	self morph owner submorphsDo: [:otherMorph |
		(otherMorph isSandblock and: [
			otherMorph preventOcclusion and: [
				otherMorph ~= self morph and: [
					(self morph bounds intersects: otherMorph bounds) and: [
						(self morph bounds containsRect: otherMorph bounds) not]]]]) ifTrue: [
			velocity := self resolveCollisionCenteredWith: otherMorph.
			hadIntersect := true]].
	(velocity closeTo: 0 @ 0)
		ifTrue: [velocity := 0 @ 0]
		ifFalse: [
			velocity := velocity * 0.5.
			self morph position: self morph position + (velocity max: velocity sign)]