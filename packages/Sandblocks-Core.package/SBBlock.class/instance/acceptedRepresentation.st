as yet unclassified
acceptedRepresentation
	" return what representations may replace you "

	^ self parentSandblock ifNotNil: [
		self parentSandblock contextAcceptedRepresentationAt: self childIndex] ifNil: [nil]