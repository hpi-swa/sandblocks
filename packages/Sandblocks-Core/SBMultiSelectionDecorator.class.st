Class {
	#name : #SBMultiSelectionDecorator,
	#superclass : #SBBlockDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBMultiSelectionDecorator >> postDrawOn: aCanvas [

	aCanvas
		frameRectangle: (self morph bounds expandBy: 2) width: self morph frameSize
		color: ((self morph parentSandblock ifNil: [self morph]) foregroundColor alpha: 0.6)
]
