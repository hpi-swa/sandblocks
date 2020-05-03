Class {
	#name : #SBExampleValueDisplay,
	#superclass : #Morph,
	#instVars : [
		'display',
		'label',
		'statusLabel',
		'hadValue'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'event handling' }
SBExampleValueDisplay >> exampleFinished: anExample [ 

	display exampleFinished: anExample.
	statusLabel contents: (hadValue
		ifTrue: ['']
		ifFalse:  ['- Not reached -'])
]

{ #category : #'event handling' }
SBExampleValueDisplay >> exampleStarting: anExample [

	display exampleStarting: anExample.
	statusLabel contents: '...'.
	hadValue := false
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		changeTableLayout;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		changeListDirection: #leftToRight;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (statusLabel := SBStringMorph new contents: '');
		addMorphBack: (display := SBWatchView new dark: true)
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> label [

	^ label contents
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> label: aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> name:  aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> reportValue: anObject [

	display reportValue: anObject.
	hadValue := true
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> reportValue: anObject name: aString [

	display reportValue: anObject.
	label contents: aString.
	hadValue := true
]
