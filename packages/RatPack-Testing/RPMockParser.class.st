Class {
	#name : #RPMockParser,
	#superclass : #Object,
	#category : #'RatPack-Testing'
}

{ #category : #'as yet unclassified' }
RPMockParser class >> fixedAnswer [

	^ Dictionary newFrom: {'a' -> 5. 'b' -> 7}
]

{ #category : #'as yet unclassified' }
RPMockParser class >> parse: anEncodedObject [

	anEncodedObject = 'invalid'
		ifTrue: [^ self error: 'Invalid content']
		ifFalse: [^ self fixedAnswer].
]
