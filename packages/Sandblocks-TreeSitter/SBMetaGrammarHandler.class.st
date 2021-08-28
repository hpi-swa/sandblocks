Class {
	#name : #SBMetaGrammarHandler,
	#superclass : #SBGrammarHandler,
	#category : #'Sandblocks-TreeSitter'
}

{ #category : #'as yet unclassified' }
SBMetaGrammarHandler >> writeSourceOn: aStream for: aBlock [

	aBlock writeMetaSourceOn: aStream
]
