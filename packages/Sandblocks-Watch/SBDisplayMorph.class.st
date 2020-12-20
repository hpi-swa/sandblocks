Class {
	#name : #SBDisplayMorph,
	#superclass : #ImageMorph,
	#category : 'Sandblocks-Watch'
}

{ #category : #'as yet unclassified' }
SBDisplayMorph class >> matches: anObject [

	^ anObject isMorph
]

{ #category : #'as yet unclassified' }
SBDisplayMorph >> dark: aBoolean [
]

{ #category : #'event handling' }
SBDisplayMorph >> exampleFinished: aSBExample [ 

]

{ #category : #'event handling' }
SBDisplayMorph >> exampleStarting: anExample [
]

{ #category : #'as yet unclassified' }
SBDisplayMorph >> reportValue: aMorph [

	| form |
	form := [aMorph imageForm]
		on: Error
		do: [ | fallback |
			fallback := Form extent: 30 asPoint depth: 32.
			fallback getCanvas
				 frameAndFillRectangle: fallback boundingBox fillColor: Color red borderWidth: 1 borderColor: Color yellow;
				 line: 0 @ 0 to: 30 asPoint width: 1 color: Color yellow;
				 line: 30 @ 0 to: 0 @ 30 width: 1 color: Color yellow.
			fallback].
	self image: ((form width > 100 or: [form height > 100]) ifTrue: [form scaledIntoFormOfSize: (100 asPoint min: form extent)] ifFalse: [form])
]
