Class {
	#name : #SBErrorDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'message'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBErrorDecorator >> attached: aMorph [

	aMorph balloonText: message.
	super attached: aMorph
]

{ #category : #'as yet unclassified' }
SBErrorDecorator >> detached: aMorph [

	aMorph balloonText: nil.
	super detached: aMorph
]

{ #category : #'as yet unclassified' }
SBErrorDecorator >> message: aString [

	message := aString
]

{ #category : #'as yet unclassified' }
SBErrorDecorator >> postDrawOn: aCanvas [

	aCanvas fillRectangle: self morph bounds color: (Color red alpha: 0.5)
]
