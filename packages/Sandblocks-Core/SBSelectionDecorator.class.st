Class {
	#name : #SBSelectionDecorator,
	#superclass : #SBBlockDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelectionDecorator >> postDrawOn: aCanvas [

	"aCanvas
		frameRectangle: (self morph bounds expandBy: 1) width: self morph frameSize
		color: (self morph parentSandblock ifNil: [self morph]) foregroundColor negated.
	
	aCanvas
		frameRectangle: (self morph bounds expandBy: 3) width: self morph frameSize
		color: (self morph parentSandblock ifNil: [self morph]) foregroundColor negated.
	"
	aCanvas
		frameRectangle: (self morph bounds expandBy: 2) width: self morph frameSize
		color: (self morph parentSandblock ifNil: [self morph]) foregroundColor
]
