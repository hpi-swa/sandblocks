Class {
	#name : #SBScmString,
	#superclass : #SBLiteral,
	#category : #'Sandblocks-Scheme'
}

{ #category : #'as yet unclassified' }
SBScmString >> absorbsInput: anEvent [

	^ SBGrammarHandler eventValidForString: anEvent
]

{ #category : #'as yet unclassified' }
SBScmString >> asSymbol: converter [
	<convert>

	converter do: [SBScmString new contents: self contents]
]

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
