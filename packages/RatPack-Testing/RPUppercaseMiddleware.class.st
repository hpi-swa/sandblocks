Class {
	#name : #RPUppercaseMiddleware,
	#superclass : #RPTestMiddleware,
	#category : #'RatPack-Testing'
}

{ #category : #interaction }
RPUppercaseMiddleware >> postHook: anEnv [

	super postHook: anEnv.
	anEnv body: anEnv body asUppercase.

	
]
