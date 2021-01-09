Class {
	#name : #SBScmBoolean,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmBoolean >> symbols [

	^ #('#' nil)
]

{ #category : #'as yet unclassified' }
SBScmBoolean >> validContents [

	^ self contents = 't' or: [self contents = 'f']
]
