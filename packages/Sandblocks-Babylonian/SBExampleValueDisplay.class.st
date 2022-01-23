Class {
	#name : #SBExampleValueDisplay,
	#superclass : #Morph,
	#instVars : [
		'display',
		'label',
		'statusLabel',
		'hadValue',
		'values'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'event handling' }
SBExampleValueDisplay >> exampleFinished: anExample [ 

	"display exampleFinished: anExample."
	
	statusLabel contents: (hadValue
		ifTrue: ['']
		ifFalse:  ['- Not reached -'])
]

{ #category : #'event handling' }
SBExampleValueDisplay >> exampleStarting: anExample [

	display exampleStarting: anExample.
	display noValue.
	
	values := OrderedCollection new.
	
	statusLabel contents: '...'.
	hadValue := false.
	
	self refreshWorld
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> filterForContextId: aNumber [

	| frames |
	frames := values select: [:probedValue |
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
		changeTableLayout;
		changeListDirection: #leftToRight;
		addMorphBack: (label := SBStringMorph new);
		addMorphBack: (statusLabel := SBStringMorph new contents: '');
		addMorphBack: (display := SBWatch watchViewClass new)
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
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand softLineOrGap])
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> name:  aString [

	label contents: aString
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> probedValues [

	^ values
]

{ #category : #'as yet unclassified' }
SBExampleValueDisplay >> reportValue: anObject name: aString [

	display reportValue: anObject.
	label contents: aString.
	hadValue := true.
	
	SBToggledCode comment: '' active: 0 do: {
		[
			values add: (SBProbedValue new
				value: anObject
				context: thisContext sender sender sender sender sender sender sender)]}
]
