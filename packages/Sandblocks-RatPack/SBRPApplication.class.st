Class {
	#name : #SBRPApplication,
	#superclass : #RPApplication,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRPApplication class >> runningServices [

	^ self services
		select: [:s | s class = self and: [s isRunning]]
]

{ #category : #routing }
SBRPApplication >> doProcessRequest: aHttpRequest [

	self
		request: aHttpRequest;
		response: (HttpResponse fromString: '').

	self requestAnalytics: SBRPRequestAnalytics new.
	self requestAnalytics initRequest: self.

	[ self parseRequestContent: aHttpRequest ]
		on: Error do: [:e | ^ self badRequest ].

	self requestAnalytics preRouting: self.
	[ self route: aHttpRequest ]
		on: Error do: [:e | self serverError: e.
			self requestAnalytics at: #exception put: e].
	self requestAnalytics postRouting: self.

	self logWindow logRequest: aHttpRequest andResponse: self response.
	^ self response

]

{ #category : #actions }
SBRPApplication >> notFound [

	| outputStream |
	outputStream := RWBinaryOrTextStream on: (String new: 100).
	outputStream nextPutAll: '404 - File Not Found'; crlf; crlf.

	self
		status: 404;
		contentType: 'text/plain';
		body: outputStream contents readStream.
]

{ #category : #routing }
SBRPApplication >> processRequest: aHttpRequest [

	aHttpRequest url = '/favicon.ico'
		ifTrue: [
			self doProcessRequest: aHttpRequest.
			self requestAnalytics finalizeRequest: self.]
		ifFalse: [ | recorder |
			recorder := MessageSendRecorder new
				watchPackageNamed: #'Sandblocks-RatPack';
				watchPackageNamed: #'Ratpack-Core';
				watchPackageNamed: #'Ratpack-Examples';
				setMessageSend: (MessageSend receiver: self selector: #doProcessRequest: argument: aHttpRequest);
				yourself.
			recorder
				recordAllObjects;
				collectTimeRatio;
				collectTimeToRun.
		self requestAnalytics
			finalizeRequest: self
			with: { #messageRecords -> recorder topRecord }.
		"recorder topRecord browse"].
	self changed: #requestHandled with: self requestAnalytics.
	
	^ self response

]

{ #category : #accessing }
SBRPApplication >> requestAnalytics [

	^ self dynamicEnvironment at: #requestAnalytics
]

{ #category : #accessing }
SBRPApplication >> requestAnalytics: aSBRPRequestAnalytics [

	self dynamicEnvironment at: #requestAnalytics put: aSBRPRequestAnalytics.
]

{ #category : #actions }
SBRPApplication >> serverError: anException [

	| outputStream |
	"self isDebugMode ifTrue: [anException signal]."

	outputStream := RWBinaryOrTextStream on: (String new: 100).
	outputStream nextPutAll: '500 - Server Error'; crlf; crlf.
	anException printVerboseOn: outputStream.

	self
		status: 500;
		contentType: 'text/plain';
		body: outputStream contents readStream.
]
