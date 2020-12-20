Class {
	#name : #SBDisplayColor,
	#superclass : #Morph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayColor class >> matches: anObject [

	^ anObject isColor
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> dark: aBoolean [
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> exampleFinished: aSBExample [ 

]

{ #category : #'as yet unclassified' }
SBDisplayColor >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> extent: aPoint [

	super extent: TextStyle defaultFont height asPoint
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> initialize [

	super initialize.
	
	self
		vResizing: #rigid;
		hResizing: #rigid;
		extent: 0 @ 0
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> minExtent [

	^ TextStyle defaultFont height asPoint
]

{ #category : #'as yet unclassified' }
SBDisplayColor >> reportValue: aColor [

	self color: aColor
]
