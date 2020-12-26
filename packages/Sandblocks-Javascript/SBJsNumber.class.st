Class {
	#name : #SBJsNumber,
	#superclass : #SBJsLiteral,
	#category : #'Sandblocks-Javascript'
}

{ #category : #'as yet unclassified' }
SBJsNumber >> valid [

	^ self contents allSatisfy: [:char | char isDigit]
]
