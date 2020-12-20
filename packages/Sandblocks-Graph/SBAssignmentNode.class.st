Class {
	#name : #SBAssignmentNode,
	#superclass : #SBNewNode,
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBAssignmentNode >> hasFlowIn [

	^ self outputSockets first connectedLinks isEmpty
]

{ #category : #'as yet unclassified' }
SBAssignmentNode >> hasFlowOut [

	^ self flowInSocket connectedLinks notEmpty
]

{ #category : #'as yet unclassified' }
SBAssignmentNode >> inputs [

	^ #('' '')
]

{ #category : #'as yet unclassified' }
SBAssignmentNode >> outputs [

	^ #(':=')
]
