Class {
	#name : #SBHorizontalLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHorizontalLayout class >> layout: aMorph in: aRectangle [

	| x |
	x := aRectangle left.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		m layoutInBounds: (x @ (aRectangle top + (aRectangle height - extent y / 2) ceiling) extent: extent).
		x := x + extent x + aMorph cellGap]
]

{ #category : #'as yet unclassified' }
SBHorizontalLayout class >> minExtentOf: aMorph in: aRectangle [

	| minHeight totalWidth |
	minHeight := 0.
	totalWidth := 0.
	self layoutMorphsOf: aMorph do: [:m | | extent |
		extent := m minExtent.
		minHeight := extent y max: minHeight.
		totalWidth := totalWidth + extent x].
	
	^ (totalWidth + (aMorph submorphCount - 1 * aMorph cellGap)) @ minHeight
]
