Class {
	#name : #SBStringRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStringRepresentation class >> matches: anObject [

	| string |
	string := (anObject isString or: [anObject isText])
		ifTrue: [anObject string]
		ifFalse: [
			((anObject respondsTo: #contents) and: [anObject contents isString]) ifTrue: [anObject contents] ifFalse: [^ false]].
	
	^ true
]

{ #category : #'as yet unclassified' }
SBStringRepresentation class >> newFor: anObject [

	^ (anObject isString or: [anObject isText]) ifTrue: [anObject] ifFalse: [anObject contents]
]
