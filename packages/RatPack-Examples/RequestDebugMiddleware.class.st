Class {
	#name : #RequestDebugMiddleware,
	#superclass : #RPMiddleware,
	#category : #'RatPack-Examples'
}

{ #category : #'as yet unclassified' }
RequestDebugMiddleware >> handle: anEnv next: aNext [
	
	aNext value.
]
