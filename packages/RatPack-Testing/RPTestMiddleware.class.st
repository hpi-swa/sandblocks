Class {
	#name : #RPTestMiddleware,
	#superclass : #RPMiddleware,
	#category : #'RatPack-Testing'
}

{ #category : #constants }
RPTestMiddleware class >> blacklist [

	^ {'/blacklistedHandler'} asOrderedCollection 
]

{ #category : #interaction }
RPTestMiddleware >> incrementPostHookCounter: anEnv [

	anEnv at: #postHookCounter 
		ifPresent: [ :counter | anEnv at: #postHookCounter put: counter +1. ]
		ifAbsent: [ anEnv at: #postHookCounter put: 1 ].
]

{ #category : #interaction }
RPTestMiddleware >> incrementPreHookCounter: anEnv [

	anEnv at: #preHookCounter 
		ifPresent: [ :counter | anEnv at: #preHookCounter put: counter +1. ]
		ifAbsent: [ anEnv at: #preHookCounter put: 1 ].
]

{ #category : #interaction }
RPTestMiddleware >> incrementTimer: anEnv [

	anEnv at: #time
		ifPresent: [ :time | anEnv at: #time put: time +1]
		ifAbsent: [ anEnv at: #time put: 1 ].
]

{ #category : #interaction }
RPTestMiddleware >> postHook: anEnv [

	self incrementPostHookCounter: anEnv.
	self incrementTimer: anEnv.
	anEnv at: (self class name, #PostHookTime) asSymbol put: (anEnv at: #time).
]

{ #category : #interaction }
RPTestMiddleware >> preHook: anEnv [

	self incrementPreHookCounter: anEnv.
	self incrementTimer: anEnv.
	anEnv at: (self class name, #PreHookTime) asSymbol put: (anEnv at: #time).
	^ true
]
