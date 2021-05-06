Class {
	#name : #SBStBuilderTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBStBuilderTest >> testAssignment [

	self assert: [:b | b assign: 'abc' to: (b number: 5)] sbStBuild isAssignment
]
