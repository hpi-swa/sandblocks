selection
selectClick: aBlock

	selectionDownHistory removeAll.
	self select: (aBlock == self selection ifTrue: [nil] ifFalse: [aBlock])