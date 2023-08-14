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
	display noValue.
	
	statusLabel contents: '...'.
	hadValue := false.
	
	self refreshWorld
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> filterForContextId: aNumber [

	| frames |
	frames := self probedValues select: [:probedValue |
		probedValue frames anySatisfy: [:frame | frame contextIdentityHash = aNumber]].
	
	self flag: #todo.
	frames ifNotEmpty: [display reportValue: frames first value]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> label [

	^ label contents
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> label: aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand gap])
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> name:  aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> probedValues [
	
	^ display values
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> reportValue: anObject name: aString [

	display reportValue: anObject.
	label contents: aString.
	hadValue := true
]
