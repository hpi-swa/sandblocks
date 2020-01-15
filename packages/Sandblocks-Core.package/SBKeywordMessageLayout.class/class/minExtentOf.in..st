as yet unclassified
minExtentOf: aMorph in: aRectangle

	| x y |
	(self wantsSingleColumn: aMorph) ifTrue: [^ SBVerticalLayout minExtentOf: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout minExtentOf: aMorph in: aRectangle].
	
	x := aMorph lastSubmorph minExtent x.
	y := 0.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		
		x := x max: nameExtent x + valueExtent x + aMorph cellGap.
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)].
	
	^ x @ y