Class {
	#name : #RPMiddleware,
	#superclass : #Object,
	#category : #'RatPack-Core'
}

{ #category : #constants }
RPMiddleware class >> blacklist [

	"Returns a collection of regular expressions. The middleware will not be executed for a request where the route matches any of these expresseions."
	^ {} asOrderedCollection
]

{ #category : #interaction }
RPMiddleware >> assertedPreHookResult: aPreHookResult [

	((aPreHookResult respondsTo: #ifTrue:) and: [ (aPreHookResult respondsTo: #ifFalse:). ])
		ifTrue: 	[ ^ aPreHookResult ]
		ifFalse: 	[ self error: 'preHook of: ' , self name , ' has to return true or false.' ]
]

{ #category : #'accessing-default' }
RPMiddleware >> handle: anEnv next: aNext [
	
	(self isUrlBlacklisted: anEnv request url)
		ifTrue: [ ^ aNext value ].
		
	(self assertedPreHookResult: (self preHook: anEnv))
		ifTrue: [ aNext value.
				 self postHook: anEnv. ].
			
]

{ #category : #interaction }
RPMiddleware >> isUrlBlacklisted: anUrl [

	self class blacklist
		detect: [ :regex | (RxMatcher forString: regex) matches: anUrl. ]
		ifNone: [ ^ false ].
	
	^ true
	
]

{ #category : #interaction }
RPMiddleware >> postHook: anEnv [

	    "Called after handler execution"

]

{ #category : #interaction }
RPMiddleware >> preHook: anEnv [

	 "Called before handler execution. Return value must understand #ifTrue: or #ifFalse:
	  Return true if you want to continue handling this request.
	  Return false if the handling should be aborted. (Post Hook is not called.)"
	
	^ true
]
