Class {
	#name : #RPGlobalHeaderMiddleware,
	#superclass : #RPMiddleware,
	#category : #'RatPack-Core'
}

{ #category : #interaction }
RPGlobalHeaderMiddleware >> preHook: anEnv [

	anEnv headersPut: anEnv settings globalHeaders.
	^ true
]
