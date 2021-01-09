Class {
	#name : #SBScmNumber,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmNumber >> validContents [

	^ (self contents first = $- or: [self contents first isDigit]) and: [self contents viewAllButFirst allSatisfy: [:c | c isDigit or: [c = $.]]]
]
