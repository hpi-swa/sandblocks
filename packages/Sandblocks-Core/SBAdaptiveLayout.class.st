Class {
	#name : #SBAdaptiveLayout,
	#superclass : #SBLayoutPolicy,
	#instVars : [
		'wrap'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> initialize [

	super initialize.
	
	wrap := false
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> layout: aMorph in: aRectangle [

	(self morph: aMorph fitsInRow: (SBNewWatch report: aRectangle width for: 814100019))
		ifTrue: [SBHorizontalLayout layout: aMorph in: aRectangle]
		ifFalse: [
			self wrap
				ifTrue: [self wrapLayout: aMorph in: aRectangle]
				ifFalse: [SBVerticalLayout layout: aMorph in: aRectangle]]
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> minExtentOf: aMorph in: aRectangle [

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self morph: aMorph fitsInRow: aRectangle width)
		ifTrue: [SBHorizontalLayout minExtentOf: aMorph in: aRectangle]
		ifFalse: [
			self wrap
				ifTrue: [self minExtentOfWrapLayout: aMorph in: aRectangle]
				ifFalse: [SBVerticalLayout minExtentOf: aMorph in: aRectangle]]
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> minExtentOfWrapLayout: aMorph in: aRectangle [

	| rowMax height maxWidth width |
	width := 0.
	height := 0.
	maxWidth := 0.
	rowMax := 0.
	self
		layoutMorphsOf: aMorph
		do: [:m | | extent |
			extent := m minExtent.
			(width + extent x) > aRectangle width ifTrue: [
				maxWidth := maxWidth max: width.
				width := 0.
				height := height + rowMax.
				rowMax := 0].
			rowMax := rowMax max: extent y.
			width := (width + extent x) + aMorph cellGap].
	height := height + rowMax.
	maxWidth := maxWidth max: width.
	^ maxWidth @ height
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> morph: aMorph fitsInRow: aNumber [

	| width |
	width := 0.
	aMorph submorphs do: [:morph |
		width := morph minExtent x + width.
		width > aNumber ifTrue: [^ false]].
	^ true
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> wrap [

	^ wrap
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> wrap: aBoolean [

	wrap := aBoolean
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> wrapLayout: aMorph in: aRectangle [

	| x y rowMax |
	x := aRectangle left.
	y := aRectangle top.
	rowMax := 0.
	self
		layoutMorphsOf: aMorph
		do: [:m | | extent |
			extent := m minExtent.
			aRectangle width.
			(x + extent x) > aRectangle right ifTrue: [
				x := aRectangle left.
				y := y + rowMax.
				rowMax := 0].
			rowMax := rowMax max: m y.
			m layoutInBounds: (x @ y extent: extent).
			x := (x + extent x) + aMorph cellGap]
]
