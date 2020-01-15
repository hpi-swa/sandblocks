as yet unclassified
layout: aMorph in: aRectangle

	(self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout layout: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout layout: aMorph in: aRectangle]