Class {
	#name : #SBComboBox,
	#superclass : #SBTextBubble,
	#instVars : [
		'values'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBComboBox >> activate [
	<action>

	
	self promptChangeValue
]

{ #category : #'as yet unclassified' }
SBComboBox >> currentTextMorph [

	^ nil
]

{ #category : #'as yet unclassified' }
SBComboBox >> display: anObject [

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
	self contents: (self display: object)
]

{ #category : #'as yet unclassified' }
SBComboBox >> promptChangeValue [

	| choice |
	choice := UIManager default
		chooseFrom: (self values collect: [:obj | self display: obj])
		values: self values.
	choice ifNotNil: [
		self sandblockEditor do: (SBMutatePropertyCommand new
			target: self;
			selector: #object;
			value: choice)]
]

{ #category : #'as yet unclassified' }
SBComboBox >> values [

	^ values
]

{ #category : #'as yet unclassified' }
SBComboBox >> values: aCollection [

	values := aCollection
]
