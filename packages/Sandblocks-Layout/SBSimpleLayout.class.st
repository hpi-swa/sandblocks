Class {
	#name : #SBSimpleLayout,
	#superclass : #SBLayoutPolicy,
	#category : #'Sandblocks-Layout'
}

{ #category : #'as yet unclassified' }
SBSimpleLayout >> layout: aMorph in: aRectangle [

	| m minExtent |
	m := aMorph submorphs detect: [:child | child disableLayout not] ifNone: [^ self].
	minExtent := m layoutPolicy
		ifNil: [m minExtent]
		ifNotNil: [m layoutPolicy minExtentOf: m in: aRectangle].
	m
		layoutInBounds: (aRectangle topLeft extent: (aMorph hResizing = #spaceFill
			ifTrue: [aRectangle width]
			ifFalse: [minExtent x]) @ (aMorph vResizing = #spaceFill
			ifTrue: [aRectangle height]
			ifFalse: [minExtent y]))
		positioning: #topLeft
]

{ #category : #'as yet unclassified' }
SBSimpleLayout >> minExtentOf: aMorph in: aRectangle [

	| m |
	m := aMorph submorphs detect: [:child | child disableLayout not] ifNone: [^ 0 @ 0].
	^ m layoutPolicy
		ifNil: [m minExtent]
		ifNotNil: [m layoutPolicy minExtentOf: m in: aRectangle]
]
