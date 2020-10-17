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

	(self morph: aMorph fitsInRow: aRectangle width)
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
		ifTrue: [
			SBHorizontalLayout minExtentOf: aMorph in: aRectangle]
		ifFalse: [
			self wrap
				ifTrue: [self minExtentOfWrapLayout: aMorph in: aRectangle]
				ifFalse: [
					SBVerticalLayout minExtentOf: aMorph in: aRectangle]]
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
				height := height + (rowMax + aMorph cellGap).
				rowMax := 0].
			rowMax := rowMax max: extent y.
			width := (width + extent x) + aMorph cellGap].
	
	height := height + rowMax.
	maxWidth := maxWidth max: width.
	^ maxWidth @ height
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> minExtentOfWrapLayout: aMorph width: aNumber [

	| rowMax height maxWidth width |
	width := 0.
	height := 0.
	maxWidth := 0.
	rowMax := 0.
	self
		layoutMorphsOf: aMorph
		do: [:m | | extent |
			extent := m minExtent.
			((width + extent x) + aMorph cellGap) > aNumber ifTrue: [
				maxWidth := maxWidth max: width - aMorph cellGap.
				width := 0.
				height := height + (rowMax + aMorph cellGap).
				rowMax := 0].
			rowMax := rowMax max: extent y.
			width := (width + extent x) + aMorph cellGap].
	height := height + rowMax.
	maxWidth := maxWidth max: width - aMorph cellGap.
	^ maxWidth @ height
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> morph: aMorph fitsInRow: aNumber [

	| width |
	width := 0.
	self
		layoutMorphsOf: aMorph
		do: [:morph |
			width := width + morph minExtent x.
			width > aNumber ifTrue: [^ false].
			width := width + aMorph cellGap].
	^ true
]

{ #category : #'as yet unclassified' }
SBAdaptiveLayout >> preferredSizeFor: aMorph width: aNumber [

	^ SBSizeRequest fixed: ((self morph: aMorph fitsInRow: aNumber)
		ifTrue: [SBHorizontalLayout minExtentOf: aMorph in: nil]
		ifFalse: [
			self wrap
				ifTrue: [self minExtentOfWrapLayout: aMorph width: aNumber]
				ifFalse: [SBVerticalLayout minExtentOf: aMorph in: nil]])
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
				y := y + (rowMax + aMorph cellGap).
				rowMax := 0].
			rowMax := rowMax max: extent y.
			m layoutInBounds: (x @ y extent: extent).
			x := (x + extent x) + aMorph cellGap]
]
