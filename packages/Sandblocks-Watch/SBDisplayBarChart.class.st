Class {
	#name : #SBDisplayBarChart,
	#superclass : #SBGraphPlot,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayBarChart class >> matches: anObject [

	^ anObject isNumber and: [anObject >= 0]
]

{ #category : #'as yet unclassified' }
SBDisplayBarChart >> dark: aBoolean [

	self labelColor: (aBoolean ifTrue: [Color white] ifFalse: [Color black])
]

{ #category : #'as yet unclassified' }
SBDisplayBarChart >> exampleFinished: aSBExample [ 

]

{ #category : #'as yet unclassified' }
SBDisplayBarChart >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayBarChart >> minExtent [

	| fontHeight |
	fontHeight := TextStyle defaultFont height.
	^ (fontHeight * 5) @ (fontHeight * 2)
]

{ #category : #'as yet unclassified' }
SBDisplayBarChart >> object [

	^ data last
]
