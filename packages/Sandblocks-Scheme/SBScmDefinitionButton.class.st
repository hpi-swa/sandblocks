Class {
	#name : #SBScmDefinitionButton,
	#superclass : #SBTextBubble,
	#instVars : [
		'sepxr'
	],
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmDefinitionButton >> object [

	^ self sexpr
]

{ #category : #'as yet unclassified' }
SBScmDefinitionButton >> sexpr [

	^ sepxr
]

{ #category : #'as yet unclassified' }
SBScmDefinitionButton >> sexpr: anSexpr [

	sepxr := anSexpr
]

{ #category : #'as yet unclassified' }
SBScmDefinitionButton >> valid [

	^ self sexpr isCollection
		ifTrue: [self sexpr allSatisfy: #valid]
		ifFalse: [self sexpr valid]
]

{ #category : #'as yet unclassified' }
SBScmDefinitionButton >> writeSourceOn: aStream [

	^ self sexpr isCollection ifTrue: [self sexpr do: [:s | s writeSourceOn: aStream indent: 0. aStream cr]] ifFalse: [self sexpr writeSourceOn: aStream indent: 0]
]
