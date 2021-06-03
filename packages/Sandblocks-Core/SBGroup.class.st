Class {
	#name : #SBGroup,
	#superclass : #RectangleMorph,
	#instVars : [
		'blocks'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBGroup class >> newFor: aForceMoveDecorator [

	^ self new addBlocksConnectedTo: aForceMoveDecorator; yourself
]

{ #category : #'as yet unclassified' }
SBGroup >> add: aForceMoveDecorator [

	self blocks add: aForceMoveDecorator morph.
	aForceMoveDecorator group: self.
	self bounds: (self bounds merge: aForceMoveDecorator morph bounds).
	self computeVertices
]

{ #category : #'as yet unclassified' }
SBGroup >> addBlocksConnectedTo: aForceMoveDecorator [

	self add: aForceMoveDecorator.
	aForceMoveDecorator additionalForces do: [:force |
		force to withDecorator: SBForceMoveDecorator do: [:decorator | self add: decorator].
		force from withDecorator: SBForceMoveDecorator do: [:decorator | self add: decorator]]
]

{ #category : #accessing }
SBGroup >> blocks [

	^ blocks
]

{ #category : #accessing }
SBGroup >> blocks: anObject [

	blocks := anObject.
]

{ #category : #nil }
SBGroup >> computeVertices [

	
]

{ #category : #nil }
SBGroup >> initialize [

	super initialize.
	self blocks: Set new
]
