"
A SBBadge displays an incrementing counter in a visual style that should help users quickly understand that it is a counter.
"
Class {
	#name : #SBBadge,
	#superclass : #SBStringMorph,
	#category : #'Sandblocks-Morphs'
}

{ #category : #accessing }
SBBadge >> color [

	^ Color white
]

{ #category : #drawing }
SBBadge >> drawOn: aCanvas [

	aCanvas fillRoundRect: self bounds radius: 4 fillStyle: Color darkGray.
	super drawOn: aCanvas
]

{ #category : #initialization }
SBBadge >> extent [

	^ 0 @ 0
]

{ #category : #initialization }
SBBadge >> initialize [

	super initialize.
	
	self
		layoutInset: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #center
]
