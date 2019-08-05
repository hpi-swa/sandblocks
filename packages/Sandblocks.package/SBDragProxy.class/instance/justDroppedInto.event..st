as yet unclassified
justDroppedInto: aMorph event: anEvent

	self flag: #todo. "refactor to use proper accept"
	(aMorph isKindOf: SBNodeSocket) ifFalse: [line delete].
	self delete