as yet unclassified
step

	(self currentPosition dist: self targetPosition) > 0
		ifTrue: [
			self basicViewportPosition: (self currentPosition interpolateTo: self targetPosition at: 0.2)]
		ifFalse: [
			self currentPosition ~= self targetPosition ifTrue: [self viewportPosition: self targetPosition rounded]]