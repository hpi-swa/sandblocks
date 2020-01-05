as yet unclassified
layout: aMorph in: aRectangle

	| y rowHeight |
	(self wantsSingleColumn: aMorph) ifTrue: [^ SBVerticalLayout new layout: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout new layout: aMorph in: aRectangle].
	
	y := aRectangle top.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		rowHeight := nameExtent y max: valueExtent y.
		
		name layoutInBounds: (aRectangle left + aMorph cellGap @ (y + (rowHeight - nameExtent y / 2) rounded) extent: nameExtent).
		value layoutInBounds: (aRectangle left + (aMorph cellGap * 2) + nameExtent x @ (y + (rowHeight - valueExtent y / 2) rounded) extent: valueExtent).
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)]