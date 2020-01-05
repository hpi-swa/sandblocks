as yet unclassified
minExtentOf: aMorph in: aRectangle

	| x y |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	(self wantsSingleColumn: aMorph) ifTrue: [^ minExtentCache := SBVerticalLayout new minExtentOf: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ minExtentCache := SBHorizontalLayout new minExtentOf: aMorph in: aRectangle].
	
	x := aMorph lastSubmorph minExtent x.
	y := 0.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		
		x := x max: nameExtent x + valueExtent x + aMorph cellGap.
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)].
	
	^ minExtentCache := x @ y