Class {
	#name : #SBErrorDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'message',
		'subtle'
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

	self subtle
		ifTrue: [aCanvas frameRoundRect: self morph bounds radius: 5 width: 3 color: (Color r: 1 g: 0.0 b: 0.0)]
		ifFalse: [aCanvas fillRectangle: self morph bounds color: ((Color r: 1 g: 0.0 b: 0.0) alpha: 0.5)]
]

{ #category : #'as yet unclassified' }
SBErrorDecorator >> subtle [

	^ subtle ifNil: [false]
]

{ #category : #'as yet unclassified' }
SBErrorDecorator >> subtle: aBoolean [

	subtle := aBoolean
]
