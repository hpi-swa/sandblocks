Class {
	#name : #SBJsNumber,
	#superclass : #SBJsLiteral,
	#category : #'Sandblocks-CustomJavascript'
}

{ #category : #'as yet unclassified' }
SBJsNumber >> valid [

	^ (self contents first = $- or: [self contents first isDigit]) and: [self contents viewAllButFirst allSatisfy: [:c | c isDigit or: [c = $.]]]
]
