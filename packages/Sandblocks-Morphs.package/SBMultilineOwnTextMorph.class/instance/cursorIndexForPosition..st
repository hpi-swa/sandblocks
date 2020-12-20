as yet unclassified
cursorIndexForPosition: aPoint

	self contents ifEmpty: [^ 0].
	^ (self paragraph characterBlockAtPoint: aPoint) stringIndex