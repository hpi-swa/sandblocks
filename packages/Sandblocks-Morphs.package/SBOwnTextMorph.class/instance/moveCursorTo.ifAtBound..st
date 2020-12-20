as yet unclassified
moveCursorTo: aNumber ifAtBound: aBlock

	(aNumber < 1 or: [aNumber > (self contents size + 1)]) ifTrue: [^ aBlock value].
	self moveCursorTo: aNumber