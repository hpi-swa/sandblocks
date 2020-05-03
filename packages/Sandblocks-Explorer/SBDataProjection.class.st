Class {
	#name : #SBDataProjection,
	#superclass : #SBBlock,
	#instVars : [
		'object'
	],
	#category : #'Sandblocks-Explorer'
}

{ #category : #'as yet unclassified' }
SBDataProjection class >> matches: anObject [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBDataProjection >> canCopy [

	^ false
]

{ #category : #'as yet unclassified' }
SBDataProjection >> initialize [

	super initialize.
	self
		attachDecorator: (SBMoveDecorator new preventOcclusion: true);
		attachDecorator: SBResizableDecorator new
]

{ #category : #'as yet unclassified' }
SBDataProjection >> object: anObject [

	object := anObject
]
