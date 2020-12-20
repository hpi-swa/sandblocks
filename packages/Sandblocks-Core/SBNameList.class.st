Class {
	#name : #SBNameList,
	#superclass : #SBArray,
	#instVars : [
		'addType'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNameList >> contextAcceptedRepresentationAt: aNumber [

	^ #isSmalltalkName
]

{ #category : #'as yet unclassified' }
SBNameList >> isExpression [

	^ false
]

{ #category : #'as yet unclassified' }
SBNameList >> newChild [

	^ SBName new
]
