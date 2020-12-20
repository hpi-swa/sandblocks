as yet unclassified
moveCursorVertically: aNumber ifAtBound: aBlock

	self moveCursorVertically: aNumber selecting: ActiveEvent shiftPressed ifAtBound: aBlock