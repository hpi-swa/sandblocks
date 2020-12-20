Class {
	#name : #RPStoppingMiddleware,
	#superclass : #RPTestMiddleware,
	#category : #'RatPack-Testing'
}

{ #category : #interaction }
RPStoppingMiddleware >> preHook: anEnv [
	
	super preHook: anEnv.
	^ false
]
