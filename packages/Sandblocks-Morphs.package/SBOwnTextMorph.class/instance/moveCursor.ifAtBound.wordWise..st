as yet unclassified
moveCursor: aNumber ifAtBound: aBlock wordWise: aBoolean

	(aBoolean and: [(aNumber < 0 and: [self cursor = 1]) or: [aNumber > 0 and: [self cursor = (self contents size + 1)]]])
		ifTrue: [^ aBlock value].
	
	self
		moveCursorTo: (aBoolean
			ifTrue: [aNumber > 0 ifTrue: [self contents size + 1] ifFalse: [1]]
			ifFalse: [self cursor + aNumber])
		ifAtBound: aBlock