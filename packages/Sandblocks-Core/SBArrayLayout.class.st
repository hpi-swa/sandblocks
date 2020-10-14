Class {
	#name : #SBArrayLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBArrayLayout >> layout: aMorph in: aRectangle [

	(self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout layout: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout layout: aMorph in: aRectangle]
]

{ #category : #'as yet unclassified' }
SBArrayLayout >> minExtentOf: aMorph in: aRectangle [

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout minExtentOf: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout minExtentOf: aMorph in: aRectangle]
]

{ #category : #'as yet unclassified' }
SBArrayLayout >> wantsMultiRow: aMorph [

	| width |
	aMorph submorphCount <= 1 ifTrue: [^ false].
	
	width := 0.
	aMorph submorphsDo: [:m |
		width := width + m minExtent x.
		width > (450 * aMorph scalingFactor) ifTrue: [^ true]].
	^ false
]
