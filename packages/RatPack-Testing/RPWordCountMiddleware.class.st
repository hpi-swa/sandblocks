Class {
	#name : #RPWordCountMiddleware,
	#superclass : #RPTestMiddleware,
	#category : #'RatPack-Testing'
}

{ #category : #interaction }
RPWordCountMiddleware >> postHook: anEnv [

	super postHook: anEnv.
	anEnv at: #wordCount put: (anEnv body subStrings size).


	
]
