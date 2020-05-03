Class {
	#name : #SBConstraintDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'lastValue',
		'target',
		'selector',
		'action'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBConstraintDecorator class >> keepCenteredOn: aMorph [

	^ self new with: #center of: aMorph do: [:center :target | target center: center]
]

{ #category : #'as yet unclassified' }
SBConstraintDecorator >> attached: aMorph [

	super attached: aMorph.
	self check
]

{ #category : #'as yet unclassified' }
SBConstraintDecorator >> check [

	| newValue |
	newValue := target perform: selector.
	(newValue ~= lastValue and: [morph notNil]) ifTrue: [
		action value: newValue value: morph.
		lastValue := newValue]
]

{ #category : #'as yet unclassified' }
SBConstraintDecorator >> detached: aMorph [

	super detached: aMorph.
	target removeDependent: self
]

{ #category : #'as yet unclassified' }
SBConstraintDecorator >> update: anAspect [

	self check
]

{ #category : #'as yet unclassified' }
SBConstraintDecorator >> with: aSymbol of: anObject do: aBlock [

	anObject addDependent: self.
	aSymbol when: #positionChanged send: #check to: self.
	target := anObject.
	selector := aSymbol.
	action := aBlock.
	self check
]
