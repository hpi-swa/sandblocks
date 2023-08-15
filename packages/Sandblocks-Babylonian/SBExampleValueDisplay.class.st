"
A row in SBExampleWatches, containing the belonging example name and a view (display) of the evaluated expression values 
"
Class {
	#name : #SBExampleValueDisplay,
	#superclass : #Morph,
	#instVars : [
		'display',
		'label',
		'statusLabel',
		'hadValue'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #accessing }
SBExampleValueDisplay >> exampleFinished: anExample [ 

	display exampleFinished: anExample.
	
	statusLabel contents: (hadValue
		ifTrue: ['']
		ifFalse:  ['- Not reached -'])
]

{ #category : #accessing }
SBExampleValueDisplay >> exampleStarting: anExample [

	display exampleStarting: anExample.
	display noValue.
	
	statusLabel contents: '...'.
	hadValue := false.
	
	self refreshWorld
]

{ #category : #initialization }
SBExampleValueDisplay >> initialize [

	super initialize.
	
	self
		color: Color transparent;
		cellGap: 4;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutPolicy: SBAlgebraLayout new;
		changeListDirection: #leftToRight;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (statusLabel := SBStringMorph new contents: '');
		addMorphBack: (display := SBExampleWatch watchViewClass saving: -1)
]

{ #category : #accessing }
SBExampleValueDisplay >> label [

	^ label contents
]

{ #category : #accessing }
SBExampleValueDisplay >> label: aString [

	label contents: aString
]

{ #category : #layout }
SBExampleValueDisplay >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]

{ #category : #naming }
SBExampleValueDisplay >> name:  aString [

	label contents: aString
]

{ #category : #'event handling' }
SBExampleValueDisplay >> reportValue: anObject name: aString [

	display reportValue: anObject.
	label contents: aString.
	hadValue := true
]
