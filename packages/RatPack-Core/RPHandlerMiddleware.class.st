Class {
	#name : #RPHandlerMiddleware,
	#superclass : #RPMiddleware,
	#instVars : [
		'application'
	],
	#category : #'RatPack-Core'
}

{ #category : #accessing }
RPHandlerMiddleware >> application [
	
	^ application

]

{ #category : #accessing }
RPHandlerMiddleware >> application: anApplication [
	
	application := anApplication.

]

{ #category : #'private-interaction' }
RPHandlerMiddleware >> isUrlBlacklisted: aUrl [

	^ false
]

{ #category : #'handler calling' }
RPHandlerMiddleware >> preHook: anEnv [

	| response |

	response := (self application
		perform: anEnv handler
		withArguments: anEnv parsedRequestArguments).
	self setBodyIfAppropiate: response in: anEnv.
	
	^ false
]

{ #category : #'private-interaction' }
RPHandlerMiddleware >> setBodyIfAppropiate: aBodyContent in: anEnv [

	"Since the handler is a method of the application, it will return the application if it has no explicit return statement"
	anEnv body: (ReadStream on: anEnv body). 
	((aBodyContent ~= self application) and: [ anEnv body isEmpty. ])
		ifTrue: [ anEnv body: (ReadStream on: aBodyContent). ].
		
]
