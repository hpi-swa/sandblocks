Class {
	#name : #SBRPModelAccessLogger,
	#superclass : #Object,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRPModelAccessLogger >> initialize [

	callList := SequenceableCollection new.
]

{ #category : #'as yet unclassified' }
SBRPModelAccessLogger >> report: aMethod pc: aNumber [

	callList add: (Dictionary new
		at: #method put: aMethod;
		at: #pc put: aNumber;
		yourself).
]
