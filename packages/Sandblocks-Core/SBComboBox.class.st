Class {
	#name : #SBComboBox,
	#superclass : #SBTextBubble,
	#instVars : [
		'values',
		'tooltips'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBComboBox >> activate [
	<action>

	
	self promptChangeValue
]

{ #category : #'as yet unclassified' }
SBComboBox >> chooseMorphs: aCollection [

	| dialog |
	dialog := DialogWindow new
		title: 'Please Choose';
		message: '';
		filterEnabled: true;
		autoCancel: true;
		yourself.
	"Like a pop-up menu, click anywhere to dismiss."
	aCollection withIndexDo: [:ea :index | dialog createButton: ea value: index].
	tooltips ifNotNil: [tooltips with: dialog buttons do: [:tooltip :button | button balloonText: tooltip]].
	dialog selectedButtonIndex: 1.
	^ dialog getUserResponseAtHand ifNotNil: [:index | aCollection at: index]
]

{ #category : #'as yet unclassified' }
SBComboBox >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBComboBox >> display: anObject [

	anObject isMorph ifTrue: [^ anObject imageForm].
	^ anObject printString
]

{ #category : #'as yet unclassified' }
SBComboBox >> doubleClick: evt [

	self promptChangeValue
]

{ #category : #'as yet unclassified' }
SBComboBox >> keyStroke: anEvent [
]

{ #category : #'as yet unclassified' }
SBComboBox >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBComboBox >> object: anObject [

	object := anObject.
	self contents: (self display: object) asString
]

{ #category : #'as yet unclassified' }
SBComboBox >> promptChangeValue [

	| choice |
	choice := (self values allSatisfy: [:val | val isMorph or: [val isForm]])
		ifTrue: [self chooseMorphs: self values]
		ifFalse: [
			UIManager default
				chooseFrom: (self values collect: [:obj | self display: obj])
				values: self values].
	
	
	choice ifNotNil: [
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #object;
			value: choice)]
]

{ #category : #'as yet unclassified' }
SBComboBox >> tooltips: aCollection [

	tooltips := aCollection
]

{ #category : #'as yet unclassified' }
SBComboBox >> values [

	^ values
]

{ #category : #'as yet unclassified' }
SBComboBox >> values: aCollection [

	values := aCollection
]
