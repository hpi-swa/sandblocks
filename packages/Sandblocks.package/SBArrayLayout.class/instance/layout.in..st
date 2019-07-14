as yet unclassified
layout: aMorph in: aRectangle

	(self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout new layout: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout new layout: aMorph in: aRectangle]