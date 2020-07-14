Class {
	#name : #SBRepresentationsTest,
	#superclass : #SBTest,
	#category : #'Sandblocks-Core-Tests'
}

{ #category : #'as yet unclassified' }
SBRepresentationsTest >> testRepresentationsThat [

	self assert: ('5+5' representationsThat: #isToplevelMorph) notEmpty
]
