Class {
	#name : #SBCTextColorPolicy,
	#superclass : #SBTextColorPolicy,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForArray: aBlock [

	^ #('[]{' '}')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForBlock: aBlock [

	^ #('{' '}')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForCharacter: aBlock [

	^ #('''' '''')
]

{ #category : #'as yet unclassified' }
SBCTextColorPolicy >> symbolsForString: aBlock [

	^ #('"' '"')
]
