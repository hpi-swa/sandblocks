Class {
	#name : #SBHighlightDecorator,
	#superclass : #SBBlockDecorator,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBHighlightDecorator >> attached: aMorph [

	super attached: aMorph.
	aMorph detachDecoratorsThat: [:d | d class = self class and: [d ~= self]]
]

{ #category : #'as yet unclassified' }
SBHighlightDecorator >> postDrawOn: aCanvas [

	aCanvas fillRectangle: self morph bounds color: (Color white alpha: 0.2)
]
