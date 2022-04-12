Class {
	#name : #SBSelect,
	#superclass : #SBTextBubble,
	#instVars : [
		'entries'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelect >> doubleClick: anEvent [

	| dialog |
	dialog := DialogWindow new
		title: 'Please Choose';
		message: '';
		filterEnabled: true;
		autoCancel: true;
		yourself.
	entries withIndexDo: [:ea :index | dialog createButton: ea value value: ea key].
	dialog selectedButtonIndex: 1.
	dialog getUserResponseAtHand ifNotNil: [:choice |
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #object;
			value: choice)]
]

{ #category : #'as yet unclassified' }
SBSelect >> entries [

	^ entries
]

{ #category : #'as yet unclassified' }
SBSelect >> entries: aCollection [

	entries := aCollection
]

{ #category : #'as yet unclassified' }
SBSelect >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBSelect >> object: anObject [

	self contents: (self entries detect: [:pair | pair key = anObject]) value.
	object := anObject
]
