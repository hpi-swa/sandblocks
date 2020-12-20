Class {
	#name : #SBLiteralNode,
	#superclass : #SBNewNode,
	#instVars : [
		'name'
	],
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBLiteralNode >> hasFlowIn [

	^ self outputSockets first connectedLinks isEmpty
]

{ #category : #'as yet unclassified' }
SBLiteralNode >> hasFlowOut [

	^ self flowInSocket connectedLinks notEmpty
]

{ #category : #'as yet unclassified' }
SBLiteralNode >> name: aString [

	name := aString.
	
	self update
]

{ #category : #'as yet unclassified' }
SBLiteralNode >> outputs [

	^ {name ifNil: ['']}
]
