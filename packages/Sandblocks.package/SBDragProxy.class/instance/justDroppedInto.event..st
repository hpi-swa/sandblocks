as yet unclassified
justDroppedInto: aMorph event: anEvent

	(aMorph respondsTo: #connectTo:) ifFalse: [line delete].
	self delete