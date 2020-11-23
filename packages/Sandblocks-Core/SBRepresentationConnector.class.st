Class {
	#name : #SBRepresentationConnector,
	#superclass : #SBConnectorLine,
	#instVars : [
		'lastSource',
		'currentRepresentation'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRepresentationConnector class >> connect: anObject to: anotherObject representation: aRepresentation [

	^ self new connect: anObject to: anotherObject representation: aRepresentation
]

{ #category : #color }
SBRepresentationConnector >> color [

	^ Color veryLightGray
]

{ #category : #'as yet unclassified' }
SBRepresentationConnector >> connect: anObject to: anotherObject representation: aRepresentationClass [

	self connect: anObject to: anotherObject.
	
	from containingArtefact when: #changed send: #update to: self.
	lastSource := from object.
	currentRepresentation := aRepresentationClass
]

{ #category : #'as yet unclassified' }
SBRepresentationConnector >> delete [

	from removeActionsWithReceiver: self.
	super delete
]

{ #category : #stepping }
SBRepresentationConnector >> step [

	| newSource |
	newSource := from object.
	(lastSource ~~ newSource and: [from isInWorld]) ifTrue: [
		(currentRepresentation matches: from object) ifTrue: [
			lastSource := newSource.
			to replace: newSource]]
]

{ #category : #stepping }
SBRepresentationConnector >> stepTime [

	^ 100
]

{ #category : #'as yet unclassified' }
SBRepresentationConnector >> update [

	(currentRepresentation matches: from object) ifTrue: [to replace: from object]
]
