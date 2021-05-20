Class {
	#name : #SBMultiSelectionDecorator,
	#superclass : #SBBlockDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMultiSelectionDecorator >> color [

	^ self morph colorPolicy selectionColorForBlock: (self morph parentSandblock ifNil: [self morph])
]

{ #category : #'as yet unclassified' }
SBMultiSelectionDecorator >> postDrawOn: aCanvas [

	aCanvas
		fillRoundRect: (self morph bounds expandBy: 2)
		radius: self morph colorPolicy cornerRadius
		fillStyle: (self color alpha: 0.6)
]
