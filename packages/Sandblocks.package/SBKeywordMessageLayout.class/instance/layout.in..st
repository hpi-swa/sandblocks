as yet unclassified
layout: aMorph in: aRectangle

	| y rowHeight |
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout new layout: aMorph in: aRectangle].
	
	y := aRectangle top.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		rowHeight := nameExtent y max: valueExtent y.
		
		name bounds: (aRectangle left + aMorph cellInset @ (y + (rowHeight - nameExtent y / 2) rounded) extent: nameExtent).
		value bounds: (aRectangle left + (aMorph cellInset * 2) + nameExtent x @ (y + (rowHeight - valueExtent y / 2) rounded) extent: valueExtent).
		y := y + aMorph cellInset + (nameExtent y max: valueExtent y)]