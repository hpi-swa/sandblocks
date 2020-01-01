as yet unclassified
step

	((self currentPosition dist: self targetPosition) closeTo: 0)
		ifFalse: [
			self basicViewportPosition: (self currentPosition interpolateTo: self targetPosition at: 0.2)]
		ifTrue: [
			self currentPosition ~= self targetPosition ifTrue: [self viewportPosition: self targetPosition rounded]]