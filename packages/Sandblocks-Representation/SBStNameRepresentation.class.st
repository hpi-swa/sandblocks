Class {
	#name : #SBStNameRepresentation,
	#superclass : #SBRepresentation,
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isLeaf [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isSmalltalkExpression [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> isSmalltalkName [

	^ true
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> matches: anObject [

	| string |
	string := (anObject isString or: [anObject isText])
		ifTrue: [anObject string]
		ifFalse: [
			((anObject respondsTo: #contents) and: [anObject isMorph and: [anObject contents isString]]) ifTrue: [anObject contents] ifFalse: [^ false]].
	
	^ string isEmpty or: [
		string first isLetter and: [string viewAllButFirst allSatisfy: #isAlphaNumeric]]
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> newFor: anObject [

	^ SBName contents: ((anObject isString or: [anObject isText]) ifTrue: [anObject] ifFalse: [anObject contents])
]

{ #category : #'as yet unclassified' }
SBStNameRepresentation class >> priority [

	^ 0
]
