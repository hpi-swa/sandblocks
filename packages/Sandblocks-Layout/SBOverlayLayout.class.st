Class {
	#name : #SBOverlayLayout,
	#superclass : #SBLayoutPolicy,
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBOverlayLayout class >> layout: aMorph in: aRectangle [

	self layoutMorphsOf: aMorph do: [:m |	m layoutInBounds: aRectangle]
]

{ #category : #'as yet unclassified' }
SBOverlayLayout class >> minExtentOf: aMorph in: aRectangle [	
	
	| m |
	m := aMorph firstSubmorph.
	^ m layoutPolicy ifNil: [m minExtent] ifNotNil: [m layoutPolicy minExtentOf: m in: aRectangle]
]
