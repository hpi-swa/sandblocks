Class {
	#name : #SBDisplayText,
	#superclass : #TextMorph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayText class >> matches: anObject [

	^ anObject isString
]

{ #category : #'as yet unclassified' }
SBDisplayText >> dark: aBoolean [

	self color: (aBoolean ifTrue: [Color white] ifFalse: [Color black])
]

{ #category : #'as yet unclassified' }
SBDisplayText >> exampleFinished: aSBExample [ 

]

{ #category : #'as yet unclassified' }
SBDisplayText >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayText >> initialize [

	super initialize.
	
	self
		contents: '---';
		readOnly: true
]

{ #category : #'as yet unclassified' }
SBDisplayText >> reportValue: anObject [

	self contents: anObject
]
