Class {
	#name : #SBKeywordMessageLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> indent [

	^ TextStyle defaultFont height
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> layout: aMorph in: aRectangle [

	| y rowHeight |
	(self wantsSingleColumn: aMorph) ifTrue: [^ SBVerticalLayout layout: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout layout: aMorph in: aRectangle].
	
	y := aRectangle top.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		rowHeight := nameExtent y max: valueExtent y.
		
		name layoutInBounds: (aRectangle left + aMorph cellGap @ (y + (rowHeight - nameExtent y / 2) rounded) extent: nameExtent).
		value layoutInBounds: (aRectangle left + (aMorph cellGap * 2) + nameExtent x @ (y + (rowHeight - valueExtent y // 2)) extent: valueExtent).
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)]
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> minExtentOf: aMorph in: aRectangle [

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
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> wantsMultiRow: aMorph [

	| sum |
	sum := 0 @ 0.
	" not an exact measure, but indicative of the space that would be taken "
	aMorph submorphs do: [:m | sum := sum + m minExtent].
	^ sum x >= self widthThreshold
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> wantsSingleColumn: aMorph [

	^ aMorph submorphCount = 2 and: [aMorph submorphs second minExtent y > 100 and: [aMorph submorphs first minExtent x > 100]]
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> wantsSingleRow: aMorph [

	^ aMorph submorphCount <= 2 or: [(self wantsMultiRow: aMorph) not]
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> widthThreshold [

	^ 400 withScalingFactor
]
