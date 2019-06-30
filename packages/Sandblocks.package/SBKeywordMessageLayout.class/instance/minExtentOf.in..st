as yet unclassified
minExtentOf: aMorph in: aRectangle

	| x y |
	aMorph submorphCount <= self breakLimit ifTrue: [^ SBExpressionLayout new minExtentOf: aMorph in: aRectangle].
	x := aMorph lastSubmorph minExtent x.
	y := 0.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		
		x := x max: self indent + nameExtent x + valueExtent x + aMorph cellInset.
		y := y + aMorph cellInset + (nameExtent y max: valueExtent y)].
	
	^ x @ y