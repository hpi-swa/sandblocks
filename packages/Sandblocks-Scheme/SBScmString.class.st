Class {
	#name : #SBScmString,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmString >> symbols [

	^ #('"' '"')
]

{ #category : #'as yet unclassified' }
SBScmString >> writeSourceOn: aStream [

	aStream nextPut: $".
	aStream nextPutAll: (self contents copyReplaceAll: '"' with: '\"').
	aStream nextPut: $"
]

{ #category : #'as yet unclassified' }
SBScmString >> writeSourceOn: aStream indent: aNumber [

	self writeSourceOn: aStream
]
