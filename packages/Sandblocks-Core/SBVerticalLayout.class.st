Class {
	#name : #SBVerticalLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBVerticalLayout class >> layout: aMorph in: aRectangle [

	| y |
	y := aRectangle top.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		m layoutInBounds: (aRectangle left @ y extent: extent).
		y := y + extent y + aMorph cellGap]
]

{ #category : #'as yet unclassified' }
SBVerticalLayout class >> minExtentOf: aMorph in: aRectangle [

	| minWidth totalHeight |
	minWidth := 0.
	totalHeight := 0.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minWidth := extent x max: minWidth.
		totalHeight := totalHeight + extent y].
	
	^ minWidth @ (totalHeight + (aMorph submorphCount - 1 * aMorph cellGap))
]
