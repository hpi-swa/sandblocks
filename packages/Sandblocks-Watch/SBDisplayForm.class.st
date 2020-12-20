Class {
	#name : #SBDisplayForm,
	#superclass : #ImageMorph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayForm class >> matches: anObject [

	^ anObject isForm
]

{ #category : #'as yet unclassified' }
SBDisplayForm >> dark: aBoolean [
]

{ #category : #'event handling' }
SBDisplayForm >> exampleFinished: aSBExample [ 

]

{ #category : #'event handling' }
SBDisplayForm >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayForm >> reportValue: aForm [

	self image: ((aForm width > 100 or: [aForm height > 100])
		ifTrue: [aForm scaledIntoFormOfSize: 100 asPoint]
	 	ifFalse: [aForm copy])
]
