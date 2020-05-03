Class {
	#name : #SBBlockBodyLayout,
	#superclass : #SBLayoutPolicy,
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBBlockBodyLayout >> layout: aMorph in: aRectangle [

	(self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout layout: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout layout: aMorph in: aRectangle]
]

{ #category : #'as yet unclassified' }
SBBlockBodyLayout >> minExtentOf: aMorph in: aRectangle [

	minExtentCache ifNotNil: [^ minExtentCache].
	
	^ minExtentCache := (self wantsMultiRow: aMorph)
		ifTrue: [SBVerticalLayout minExtentOf: aMorph in: aRectangle]
		ifFalse: [SBHorizontalLayout minExtentOf: aMorph in: aRectangle]
]

{ #category : #'as yet unclassified' }
SBBlockBodyLayout >> wantsMultiRow: aMorph [

	^ aMorph temporaries notEmpty or: [aMorph statementCount > 1 or: [aMorph statementCount > 0 and: [aMorph statements first minExtent x > (350 withScalingFactor)]]]
]
