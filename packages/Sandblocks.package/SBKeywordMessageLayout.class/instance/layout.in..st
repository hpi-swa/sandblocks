as yet unclassified
layout: aMorph in: aRectangle

	| y rowHeight |
	aMorph submorphCount <= self breakLimit ifTrue: [^ SBExpressionLayout new layout: aMorph in: aRectangle].
	
	y := aRectangle top.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		rowHeight := nameExtent y max: valueExtent y.
		
		name bounds: (aRectangle left + self indent @ (y + (rowHeight - nameExtent y / 2)) extent: nameExtent).
		value bounds: (aRectangle left + self indent + aMorph cellInset + nameExtent x @ (y + (rowHeight - valueExtent y / 2)) extent: valueExtent).
		y := y + (nameExtent y max: valueExtent y)].
	
	"trailingExtent := aMorph lastSubmorph minExtent.
	aMorph lastSubmorph bounds: (aRectangle corner - trailingExtent extent: trailingExtent)"