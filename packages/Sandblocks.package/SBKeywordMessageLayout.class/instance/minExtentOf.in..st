as yet unclassified
minExtentOf: aMorph in: aRectangle

	| x y |
	minExtentCache ifNotNil: [^ minExtentCache].
	
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout new minExtentOf: aMorph in: aRectangle].
	
	x := aMorph lastSubmorph minExtent x.
	y := 0.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		
		x := x max: nameExtent x + valueExtent x + aMorph cellInset.
		y := y + aMorph cellInset + (nameExtent y max: valueExtent y)].
	
	^ minExtentCache := x @ y