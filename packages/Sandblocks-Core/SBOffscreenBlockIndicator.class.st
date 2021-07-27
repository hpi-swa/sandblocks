Class {
	#name : #SBOffscreenBlockIndicator,
	#superclass : #Morph,
	#instVars : [
		'target',
		'iconMorph',
		'labelMorph',
		'lastPosition',
		'isHighlighted'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator class >> defaultOpacity [

	^ 0.6
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator class >> newFor: aMorph [

	^ self new 
		target: aMorph; 
		yourself.
	 
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> containingSandblock [

	^ self
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> fixedNumberOfChildren [

	^ true
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> foregroundColor [

	^ (self sandblockEditor search isSelected
		ifTrue: self owner containingSandblock colorPolicy highlightColor
		ifFalse: [self owner containingSandblock foregroundColor]) alpha: self class defaultOpacity
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> handlesMouseDown: anEvent [

	^ self visible
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
SBOffscreenBlockIndicator >> indicatorColor: aColor [

	self iconMorph color: aColor.
	self labelMorph color: aColor
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> initialize [

	super initialize.
	
	self iconMorph: SBIcon iconCaretSquareORight veryLarge.
	self addMorph: self iconMorph.
	
	self labelMorph: SBStringMorph new.
	self addMorph: self labelMorph.
	self labelMorph opacity: self class defaultOpacity.
	self isHighlighted: false.
	self color: Color transparent
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> isHighlighted [

	^ isHighlighted
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> isHighlighted: aBoolean [

	isHighlighted := aBoolean
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
	
	self target isSandblock ifTrue: [self sandblockEditor select: self target].
	Project current addDeferredUIMessage: [self scroller scrollToCenter: self target]
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> objectInterface [

	^ SBInterfaces never
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

	self sandblockEditor selection ifNotNil: [:selection |
		selection
			withDecorator: SBWaypointMoveDecorator
			do: [:decorator | ^ (decorator morph targets includes: self target) not]
			ifAbsent: []].
	self sandblockEditor search isSelected ifTrue: [^ (self sandblockEditor search matchedArtefacts includes: self target) not].
	^ self shouldHideDefault
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> shouldHideDefault [

	^ SBPreferences hideIndicators or: [(self target withDecorator: SBForceMoveDecorator do: [:decorator | 
			decorator group notNil]
			ifAbsent: [false]) and: [self isHighlighted not]]
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> specialDropCommand: aBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> step [

	| viewCenter direction intersections viewRectangle position |
	self target ifNil: [^ self abandon].
	
	(self targetOffscreen and: [self shouldHide not])
		ifTrue: [self show]
		ifFalse: [
			"Workaround for invisible indicators snacking our events."
			self position: 0@0.
			^ self hide].
	
	self updateLabel.
	
	viewRectangle := self scroller innerBounds.
	viewCenter := viewRectangle center.
	direction := (self target boundsInWorld center - self scroller innerBoundsInWorld center) normalized.
	
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
	self	updateLabel.
	aMorph when: #delete send: #abandon to: self
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> targetOffscreen [

	^ (self scroller innerBoundsInWorld intersects: self target boundsInWorld) not
]

{ #category : #'as yet unclassified' }
SBOffscreenBlockIndicator >> toggleHighlight [

	self isHighlighted: self isHighlighted not.
	self indicatorColor: (self isHighlighted
		ifTrue: [ | newColor |
			newColor := self target group
				ifNotNil: [:group | group color alpha: self class defaultOpacity]
				ifNil: [Color random].
			self target colorPolicy dark
				ifTrue: [newColor thriceLighter]
				ifFalse: [newColor muchDarker]]
		ifFalse: [nil])
]

{ #category : #accessing }
SBOffscreenBlockIndicator >> updateLabel [

	self labelMorph contents: self target textContents
]
