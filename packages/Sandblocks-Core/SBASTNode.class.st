Class {
	#name : #SBASTNode,
	#superclass : #SBBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBASTNode >> acceptedRepresentation [

	^ (self parentSandblock notNil and: [self parentSandblock isASTNode]) ifTrue: [
		self parentSandblock contextAcceptedRepresentationAt: self childIndex] ifFalse: [nil]
]

{ #category : #'as yet unclassified' }
SBASTNode >> contextAcceptedRepresentationAt: aNumber [

	^ #isSmalltalkExpression
]

{ #category : #'as yet unclassified' }
SBASTNode >> handleDroppedBlock: aBlock event: anEvent [

	| replacer |
	replacer := aBlock object representationThat: (self parentSandblock contextAcceptedRepresentationAt: self childIndex).
	self sandblockEditor do: ((SBReplaceCommand newFor: self containingArtefact)
		target: self;
		replacer: replacer).
	replacer postDuplicate
]

{ #category : #'as yet unclassified' }
SBASTNode >> isASTNode [

	^ true
]

{ #category : #'as yet unclassified' }
SBASTNode >> object [

	^ self
]
