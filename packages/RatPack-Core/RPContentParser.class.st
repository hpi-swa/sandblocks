Class {
	#name : #RPContentParser,
	#superclass : #Object,
	#category : #'RatPack-Core'
}

{ #category : #'as yet unclassified' }
RPContentParser class >> parse: aString [
	^ self subclassResponsibility
]
