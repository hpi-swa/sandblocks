Class {
	#name : #SBSelect,
	#superclass : #SBTextBubble,
	#instVars : [
		'entries'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSelect >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBSelect >> doubleClick: anEvent [

	| dialog |
	dialog := DialogWindow new
		title: 'Please Choose';
		message: '';
		filterEnabled: true;
		autoCancel: true;
		yourself.
	entries withIndexDo: [:ea :index | | button |
		button := dialog createButton: ea value value: ea key.
		ea value isMorph ifTrue: [button balloonText: ea value balloonText].
		button].
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
	"{key -> label. ...}"

	entries := aCollection
]

{ #category : #'as yet unclassified' }
SBSelect >> entryMorphs: aCollection [
	"{{label. image. tooltip} ...}"

	self entries: (aCollection collect: [:tuple |
		tuple first -> (SBRow new
			cellGap: 8;
			cellPositioning: #center;
			addMorphBack: (SBStringMorph new contents: tuple first);
			addMorphBack: tuple second;
			balloonText: tuple third)])
]

{ #category : #'as yet unclassified' }
SBSelect >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBSelect >> object: anObject [

	| label |
	label := (self entries detect: [:pair | pair key = anObject]) value.
	label isMorph
		ifTrue: [self firstSubmorph replaceBy: label]
		ifFalse: [self contents: label].
	object := anObject
]
