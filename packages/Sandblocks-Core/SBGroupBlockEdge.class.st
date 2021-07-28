Class {
	#name : #SBGroupBlockEdge,
	#superclass : #Object,
	#instVars : [
		'block',
		'position',
		'side'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGroupBlockEdge class >> expandBy [ 
	
	^ 10@10
]

{ #category : #'as yet unclassified' }
SBGroupBlockEdge class >> leftEdgeOf: aBlock [
	
	^ self new
		block: aBlock;
		position: (aBlock bounds expandBy: self expandBy) left;
		side: #left
]

{ #category : #'as yet unclassified' }
SBGroupBlockEdge class >> rightEdgeOf: aBlock [
	
	^ self new
		block: aBlock;
		position: (aBlock bounds expandBy: self expandBy) right;
		side: #right
]

{ #category : #accessing }
SBGroupBlockEdge >> block [

	^ block
]

{ #category : #accessing }
SBGroupBlockEdge >> block: anObject [

	block := anObject.
]

{ #category : #'as yet unclassified' }
SBGroupBlockEdge >> expandedBounds [
	
	^ self block bounds expandBy: self class expandBy
]

{ #category : #accessing }
SBGroupBlockEdge >> position [

	^ position
]

{ #category : #accessing }
SBGroupBlockEdge >> position: anObject [

	position := anObject.
]

{ #category : #accessing }
SBGroupBlockEdge >> side [

	^ side
]

{ #category : #accessing }
SBGroupBlockEdge >> side: anObject [

	side := anObject.
]
