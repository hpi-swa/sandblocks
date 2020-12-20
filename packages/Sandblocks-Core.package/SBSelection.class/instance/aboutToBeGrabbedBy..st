as yet unclassified
aboutToBeGrabbedBy: aHand

	super aboutToBeGrabbedBy: aHand.
	self align: self fullBounds topLeft with: aHand position + (aHand extent // 3).
	aHand newKeyboardFocus: self