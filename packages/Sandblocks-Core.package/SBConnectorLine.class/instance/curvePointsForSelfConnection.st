as yet unclassified
curvePointsForSelfConnection

	| pivot |
	pivot := from topCenter.
	^ {
		(from width > 40 ifTrue: [pivot + (-20 @ 0)] ifFalse: [from topLeft]).
		(pivot + (-20 @ self selfConnectionSize negated)).
		(pivot + (20 @ self selfConnectionSize negated)).
		(from width > 40 ifTrue: [pivot + (20 @ 0)] ifFalse: [from topRight])
	}