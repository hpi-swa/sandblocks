Class {
	#name : #SBRegexExample,
	#superclass : #SBTextBubble,
	#instVars : [
		'regex'
	],
	#category : 'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBRegexExample >> printOn: aStream [

	aStream nextPutAll: 'regex example'
]

{ #category : #'as yet unclassified' }
SBRegexExample >> regex: aRegex [

	regex := aRegex
]

{ #category : #'as yet unclassified' }
SBRegexExample >> valid [

	^ regex regexMatches: self contents
]
