Class {
	#name : #SBScmNumber,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmNumber >> validContents [

	^ self contents allSatisfy: [:c | c isDigit or: [c = $.]]
]
