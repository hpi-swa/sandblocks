Class {
	#name : #SBScmNumber,
	#superclass : #SBScmLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmNumber >> validContents [

	^ (self contents first = $- or: [self contents first isDigit]) and: [self contents viewAllButFirst allSatisfy: [:c | c isDigit or: [c = $.]]]
]
