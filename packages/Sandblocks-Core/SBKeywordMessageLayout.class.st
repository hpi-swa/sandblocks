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

	| y rowHeight keywordWidth alignKeywords |
	(self wantsSingleColumn: aMorph) ifTrue: [^ SBVerticalLayout layout: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout layout: aMorph in: aRectangle].
	
	y := aRectangle top.
	alignKeywords := self wantsAlignedKeywords: aMorph.
	keywordWidth := self maxKeywordWidth: aMorph.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent left |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		rowHeight := nameExtent y max: valueExtent y.
		left := aRectangle left + (alignKeywords ifTrue: [keywordWidth - (nameExtent x)] ifFalse: [0]).
		
		name layoutInBounds: (left + aMorph cellGap @ (y + (rowHeight - nameExtent y / 2) rounded) extent: nameExtent).
		value layoutInBounds: (left + (aMorph cellGap * 2) + nameExtent x @ (y + (rowHeight - valueExtent y // 2)) extent: valueExtent).
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)]
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> maxKeywordWidth: aMorph [

	^ (aMorph submorphs viewFrom: 1 to: aMorph submorphCount by: 2) inject: 0 into: [:width :keyword | width max: keyword minExtent x]
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> minExtentOf: aMorph in: aRectangle [

	| x y keywordWidth alignKeywords |
	(self wantsSingleColumn: aMorph) ifTrue: [^ SBVerticalLayout minExtentOf: aMorph in: aRectangle].
	(self wantsSingleRow: aMorph) ifTrue: [^ SBHorizontalLayout minExtentOf: aMorph in: aRectangle].
	
	x := aMorph lastSubmorph minExtent x.
	y := 0.
	keywordWidth := self maxKeywordWidth: aMorph.
	alignKeywords := self wantsAlignedKeywords: aMorph.
	aMorph submorphs pairsDo: [:name :value | | nameExtent valueExtent |
		nameExtent := name minExtent.
		valueExtent := value minExtent.
		
		x := x max: (alignKeywords ifTrue: [keywordWidth] ifFalse: [nameExtent x]) + valueExtent x + aMorph cellGap.
		y := y + aMorph cellGap + (nameExtent y max: valueExtent y)].
	
	^ x @ y
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> preferredSizeFor: aMorph width: aNumber [

	^ SBSizeRequest fixed: 100 @ 100
]

{ #category : #'as yet unclassified' }
SBKeywordMessageLayout class >> wantsAlignedKeywords: aMorph [

	^ (self maxKeywordWidth: aMorph) < 300
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

	^ 500 withScalingFactor
]
