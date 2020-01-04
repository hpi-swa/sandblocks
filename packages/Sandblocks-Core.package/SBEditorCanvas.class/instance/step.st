as yet unclassified
step

	(dragLeftOverVelocity closeTo: 0 @ 0)
		ifTrue: [
			((self currentPosition dist: self targetPosition) closeTo: 0)
				ifTrue: [self currentPosition ~= self targetPosition ifTrue: [self viewportPosition: self targetPosition rounded]]
				ifFalse: [self basicViewportPosition: (self currentPosition interpolateTo: self targetPosition at: 0.2)]]