Class {
	#name : #SBFlashDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'endTime'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBFlashDecorator >> attached: aMorph [

	super attached: aMorph.
	endTime := Time millisecondClock + self duration
]

{ #category : #'as yet unclassified' }
SBFlashDecorator >> color [

	^ (Color r: 1 g: 1 b: 0.0) alpha: (endTime - Time millisecondClock / self duration) asFloat
]

{ #category : #'as yet unclassified' }
SBFlashDecorator >> duration [

	^ 400
]

{ #category : #'as yet unclassified' }
SBFlashDecorator >> postDrawOn: aCanvas [

	self color alpha.
	aCanvas frameRectangle: self morph bounds width: 4 color: self color
]

{ #category : #'as yet unclassified' }
SBFlashDecorator >> step [

	Time millisecondClock > endTime ifTrue: [self detach].
	self morph changed
]

{ #category : #'as yet unclassified' }
SBFlashDecorator >> stepTime [

	^ 0
]
