Class {
	#name : #SBStEmptyLine,
	#superclass : #SBEmptyLine,
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #'as yet unclassified' }
SBStEmptyLine >> isSmalltalk [

	^ true
]

{ #category : #'as yet unclassified' }
SBStEmptyLine >> writeSourceOn: aStream [

	aStream nextPutAll: '#ppEmptyLine'
]
