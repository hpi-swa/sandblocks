Class {
	#name : #SBVerticalLayout,
	#superclass : #SBLayoutPolicy,
	#category : #'Sandblocks-Layout'
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

	| minWidth totalHeight count |
	minWidth := 0.
	totalHeight := 0.
	count := self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minWidth := extent x max: minWidth.
		totalHeight := totalHeight + extent y].
	
	^ minWidth @ (totalHeight + (count - 1 * aMorph cellGap))
]
