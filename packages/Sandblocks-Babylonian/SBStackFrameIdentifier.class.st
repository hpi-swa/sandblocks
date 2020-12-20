Class {
	#name : #SBStackFrameIdentifier,
	#superclass : #Object,
	#instVars : [
		'method',
		'contextIdentityHash',
		'contextPc'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'as yet unclassified' }
SBStackFrameIdentifier >> context: aContext [

	method := aContext method.
	contextIdentityHash := aContext identityHash.
	contextPc := aContext previousPc
]

{ #category : #'as yet unclassified' }
SBStackFrameIdentifier >> contextIdentityHash [

	^ contextIdentityHash
]

{ #category : #'as yet unclassified' }
SBStackFrameIdentifier >> contextPc [

	^ contextPc
]

{ #category : #'as yet unclassified' }
SBStackFrameIdentifier >> method [

	^ method
]

{ #category : #'as yet unclassified' }
SBStackFrameIdentifier >> printOn: aStream [

	aStream nextPutAll: self className; nextPut: $(; print: method; nextPut: $,; print: contextIdentityHash; nextPut: $,; print: contextPc; nextPut: $)
]
