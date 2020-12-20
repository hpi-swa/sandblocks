Class {
	#name : #SBDisplayCanvas,
	#superclass : #ImageMorph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayCanvas class >> matches: anObject [

	^ anObject isKindOf: Canvas
]

{ #category : #'as yet unclassified' }
SBDisplayCanvas >> dark: aBoolean [
]

{ #category : #'event handling' }
SBDisplayCanvas >> exampleFinished: aSBExample [ 

]

{ #category : #'event handling' }
SBDisplayCanvas >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayCanvas >> reportValue: aCanvas [

	self image: ((aCanvas form width > 100 or: [aCanvas form height > 100])
		ifTrue: [aCanvas form scaledIntoFormOfSize: 100 asPoint]
	 	ifFalse: [aCanvas form copy])
]
