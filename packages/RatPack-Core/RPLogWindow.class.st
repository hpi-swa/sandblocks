Class {
	#name : #RPLogWindow,
	#superclass : #TranscriptStream,
	#instVars : [
		'loggingIsEnabled'
	],
	#category : #'RatPack-Core'
}

{ #category : #'private-interaction' }
RPLogWindow >> buildRequestLogMessageFrom: aHttpRequest [ 

	| ip time url method |
	ip := self getIpFrom: aHttpRequest.
	time := Date dateAndTimeNow asString.
	url := aHttpRequest url.
	method := aHttpRequest method.
	^ '{1} {2} {3} {4} ' format: {time. ip. method. url}
]

{ #category : #'private-interaction' }
RPLogWindow >> buildResponseLogMessageFrom: aHttpResponse [ 

	^ aHttpResponse status asString
]

{ #category : #accessing }
RPLogWindow >> disableLogging [ 

	self closeAllViews.
	loggingIsEnabled := false
]

{ #category : #accessing }
RPLogWindow >> enableLogging [ 

	self open.
	loggingIsEnabled := true
]

{ #category : #'private-interaction' }
RPLogWindow >> getIpFrom: aHttpRequest [ 

	[^ aHttpRequest remoteAddress asIpString] on: MessageNotUnderstood do: [^ 'unknown IP']
	
]

{ #category : #'private-interaction' }
RPLogWindow >> logRequest: aHttpRequest andResponse: aHttpResponse [

	| responseMessage requestMessage |
	(self loggingIsEnabled)
		ifTrue: [requestMessage := self buildRequestLogMessageFrom: aHttpRequest.
				responseMessage := self buildResponseLogMessageFrom: aHttpResponse.
				self show: (requestMessage, ' ', responseMessage); cr]
]

{ #category : #accessing }
RPLogWindow >> loggingIsEnabled [ 

	^ loggingIsEnabled
]
