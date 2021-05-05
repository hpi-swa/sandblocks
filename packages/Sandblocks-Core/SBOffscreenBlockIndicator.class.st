Class {
	#name : #SBOffscreenBlockIndicator,
	#superclass : #Morph,
	#instVars : [
		'target',
		'scroller'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator class >> newFor: aMorph withScroller: aScroller [

	^ self new 
		target: aMorph; 
		scroller: aScroller.
	 
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> initialize [

	super initialize.
	self addMorph: (SBIcon iconCaretSquareORight veryLarge).
	self color: Color transparent.
	
	
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> scroller [

	^ scroller
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> scroller: aScroller [

	scroller := aScroller.
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> step [

	| viewCenter direction viewExtent distanceFromCenter |

	self target ifNil: [^ self abandon].

	self targetOffscreen 
		ifTrue: [self show]
		ifFalse: [self hide].
	viewCenter := self scroller innerBounds center.
	direction := (self target boundsInWorld center - viewCenter) normalized.
	viewExtent := self scroller innerBounds extent.
	distanceFromCenter := (viewExtent x min: viewExtent y) / 2.
	self firstSubmorph rotationDegrees: direction degrees.
	self position: (self scroller transform invertPoint: (viewCenter + (direction * distanceFromCenter))).
	Transcript showln: self position.
	

]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> stepTime [

	 ^ 10
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> target [

	^ target
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> target: aMorph [

	target := aMorph
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> targetOffscreen [

	^ (self scroller innerBounds intersects: self target boundsInWorld) not.
]
