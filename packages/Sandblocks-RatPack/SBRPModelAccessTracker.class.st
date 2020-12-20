Class {
	#name : #SBRPModelAccessTracker,
	#superclass : #SBColorPolicy,
	#instVars : [
		'callList'
	],
	#category : #'Sandblocks-RatPack'
}

{ #category : #nil }
SBRPModelAccessTracker >> initialize [

	callList := SequenceableCollection new.
]

{ #category : #'as yet unclassified' }
SBRPModelAccessTracker >> report: aMethod pc: aNumber [

	callList add: (Dictionary new
		at: #method put: aMethod;
		at: #pc put: aNumber;
		yourself).
]
