Class {
	#name : #SBStateMachineTransition,
	#superclass : #SBConnectorLine,
	#instVars : [
		'conditions'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> addCondition: aBlock [

	conditions addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> conditions [

	^ conditions
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> doLayoutIn: aRectangle [

	conditions center: aRectangle center.
	super doLayoutIn: aRectangle
]

{ #category : #'as yet unclassified' }
SBStateMachineTransition >> initialize [

	super initialize.
	
	conditions := SBArray new.
	
	self addMorphBack: conditions
]
