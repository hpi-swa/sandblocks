Class {
	#name : #SBReturnNode,
	#superclass : #SBNewNode,
	#category : 'Sandblocks-Graph'
}

{ #category : #'as yet unclassified' }
SBReturnNode >> hasFlowIn [

	^ true
]

{ #category : #'as yet unclassified' }
SBReturnNode >> hasFlowOut [

	^ false
]

{ #category : #'as yet unclassified' }
SBReturnNode >> inputs [

	^ #('^')
]
