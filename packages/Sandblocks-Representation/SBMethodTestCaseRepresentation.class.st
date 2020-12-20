Class {
	#name : #SBMethodTestCaseRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMethodTestCaseRepresentation class >> isToplevelMorph [

	^ true
]

{ #category : #'as yet unclassified' }
SBMethodTestCaseRepresentation class >> matches: anObject [

	^ anObject isCompiledMethod and: [anObject selector isTestSelector and: [anObject selector isUnary and: [anObject methodClass isTestClass]]]
]

{ #category : #'as yet unclassified' }
SBMethodTestCaseRepresentation class >> newFor: anObject [

	| block |
	block := anObject asSandblock.
	^ SBTestCase new
		selector: block selector arguments: block arguments class: block methodClass;
		body: block body;
		yourself
]
