Class {
	#name : #SBComboBox,
	#superclass : #SBTextBubble,
	#instVars : [
		'values',
		'tooltips',
		'labels'
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
	aCollection withIndexDo: [:ea :index | dialog createButton: ea value: index].
	(tooltips ifNil: [aCollection collect: #balloonText])
		with: dialog buttons
		do: [:tooltip :button | button balloonText: tooltip].
	dialog selectedButtonIndex: 1.
	^ dialog getUserResponseAtHand
]

{ #category : #'as yet unclassified' }
SBComboBox >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBComboBox >> display: anObject [

	anObject isMorph ifTrue: [^ anObject imageForm].
	anObject isString ifTrue: [^ anObject].
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
SBComboBox >> labels [

	^ labels
]

{ #category : #'as yet unclassified' }
SBComboBox >> labels: aCollection [

	labels := aCollection
]

{ #category : #'as yet unclassified' }
SBComboBox >> object [

	^ object
]

{ #category : #'as yet unclassified' }
SBComboBox >> object: anObject [

	object := anObject.
	anObject ifNotNil: [ | actualLabels |
		self labels
			ifNotNil: [
				actualLabels := self labels ifNil: [self values].
				self contents: (self display: (actualLabels at: (self values indexOf: anObject)))]
			ifNil: [self contents: (self display: anObject) asString]].
	self triggerEvent: #selectionChanged with: anObject
]

{ #category : #'as yet unclassified' }
SBComboBox >> promptChangeValue [

	| choice actualLabels |
	actualLabels := self labels ifNil: [self values].
	choice := (actualLabels allSatisfy: [:val | val isMorph or: [val isForm]])
		ifTrue: [(self chooseMorphs: actualLabels) ifNotNil: [:index | self values at: index]]
		ifFalse: [
			UIManager default
				chooseFrom: (actualLabels collect: [:obj | self display: obj])
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
