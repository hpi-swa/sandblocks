Class {
	#name : #SBMessageNode,
	#superclass : #SBNewNode,
	#instVars : [
		'selector',
		'inCascade'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBMessageNode >> hasFlowIn [

	^ self outputSockets first connectedLinks isEmpty
]

{ #category : #'as yet unclassified' }
SBMessageNode >> hasFlowOut [

	^ self flowInSocket connectedLinks notEmpty or: [self inCascade]
]

{ #category : #'as yet unclassified' }
SBMessageNode >> inCascade [

	^ inCascade
]

{ #category : #'as yet unclassified' }
SBMessageNode >> inCascade: aBoolean [

	inCascade := aBoolean.
	self update
]

{ #category : #'as yet unclassified' }
SBMessageNode >> initialize [

	inCascade := false.
	
	super initialize
]

{ #category : #'as yet unclassified' }
SBMessageNode >> inputs [

	^ self selector isUnary
		ifTrue: [#('self')]
		ifFalse: [#('self'), self selector keywords]
]

{ #category : #'as yet unclassified' }
SBMessageNode >> outputs [

	^ self selector isUnary
		ifTrue: [{self selector asString}]
		ifFalse: [#('')]
]

{ #category : #'as yet unclassified' }
SBMessageNode >> selector [

	^ selector ifNil: [#'']
]

{ #category : #'as yet unclassified' }
SBMessageNode >> selector: aSymbol [

	selector := aSymbol.
	
	self update
]
