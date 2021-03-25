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
