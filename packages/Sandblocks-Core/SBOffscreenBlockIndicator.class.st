Class {
	#name : #SBOffscreenBlockIndicator,
	#superclass : #Morph,
	#instVars : [
		'target',
		'iconMorph',
		'labelMorph',
		'lastPosition'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator class >> newFor: aMorph [

	^ self new 
		target: aMorph; 
		yourself.
	 
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> handlesMouseDown: anEvent [

	^ true
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> iconMorph [

	^ iconMorph
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> iconMorph: anObject [

	iconMorph := anObject.
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> initialize [

	super initialize.
	
	self iconMorph: SBIcon iconCaretSquareORight veryLarge.
	self addMorph: self iconMorph.
	
	self color: Color transparent.
	
	
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> labelMorph [

	^ labelMorph
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> labelMorph: anObject [

	labelMorph := anObject.
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> lastPosition [

	^ lastPosition
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> lastPosition: anObject [

	lastPosition := anObject.
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> mouseDown: anEvent [
	
	self scroller scrollToShow: self target.
]

{ #category : #nil }
SBOffscreenBlockIndicator >> rejectsEvent: anEvent [
	
	(anEvent isMouse and: [anEvent isMouseDown] and: [anEvent redButtonChanged])
		ifTrue: 
			[^ (self iconMorph boundsInWorld containsPoint: anEvent position) not]
		ifFalse: [^ true].
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> scroller [

	^ self sandblockEditor canvas.
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> shouldHide [

	^ self target withDecorator: SBForceMoveDecorator 
		do: [:decorator | decorator group notNil]
		ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> step [

	| viewCenter direction intersections viewRectangle position |
	self target ifNil: [^ self abandon].
	
	(self targetOffscreen and: [self shouldHide not]) ifTrue: [self show] ifFalse: [^ self hide].
	
	viewCenter := self scroller innerBounds center.
	direction := (self target boundsInWorld center - viewCenter) normalized.
	viewRectangle := self scroller innerBounds.
	
	intersections := {
		LineSegment intersectFrom: viewCenter with: direction to: viewRectangle topLeft with: 0 @ 1.
		LineSegment intersectFrom: viewCenter with: direction to: viewRectangle topLeft with: 1 @ 0.
		LineSegment intersectFrom: viewCenter with: direction to: viewRectangle bottomRight with: -1 @ 0.
		LineSegment intersectFrom: viewCenter with: direction to: viewRectangle bottomRight with: 0 @ -1}.
	
	position := intersections detect: [:aPoint | aPoint notNil and: [viewRectangle containsPoint: aPoint - direction]].
	lastPosition = position ifTrue: [^ self].
	lastPosition := position.
	
	self center: position - (direction * self iconMorph extent / 2).
	self labelMorph center: self center - (direction * (self labelMorph extent / 2 + self iconMorph extent)).
	
	self iconMorph rotationDegrees: direction degrees
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

	target := aMorph.
	
	self
		labelMorph: SBStringMorph new;
		updateLabel;
		addMorph: self labelMorph.
		
	aMorph when: #delete send: #abandon to: self.
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> targetOffscreen [

	^ (self scroller innerBounds intersects: self target boundsInWorld) not.
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> updateLabel [

	self labelMorph contents: self target textContents
]
