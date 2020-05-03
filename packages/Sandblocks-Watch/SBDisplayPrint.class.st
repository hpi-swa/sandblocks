Class {
	#name : #SBDisplayPrint,
	#superclass : #StringMorph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayPrint class >> matches: anObject [

	^ true
]

{ #category : #'as yet unclassified' }
SBDisplayPrint >> dark: aBoolean [

	self color: (aBoolean ifTrue: [Color white] ifFalse: [Color black])
]

{ #category : #'as yet unclassified' }
SBDisplayPrint >> exampleFinished: aSBExample [ 

]

{ #category : #'as yet unclassified' }
SBDisplayPrint >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayPrint >> initialize [

	super initialize.
	
	self contents: '---'
]

{ #category : #'as yet unclassified' }
SBDisplayPrint >> reportValue: anObject [

	self contents: (anObject printStringLimitedTo: 30)
]
