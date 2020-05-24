Class {
	#name : #SBNavigation,
	#superclass : #Object,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBNavigation >> nextFrom: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBNavigation >> nextFrom: aMorph do: aBlock [

	^ (self nextFrom: aMorph) ifNotNil: [:b | aBlock value: b]
]

{ #category : #'as yet unclassified' }
SBNavigation >> previousFrom: aBlock [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBNavigation >> previousFrom: aMorph do: aBlock [

	^ (self previousFrom: aMorph) ifNotNil: [:b | aBlock value: b]
]
