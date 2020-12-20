Class {
	#name : #SBRPApplication,
	#superclass : #RPApplication,
	#category : #'Sandblocks-RatPack'
}

{ #category : #routing }
SBRPApplication >> doProcessRequest: aHttpRequest [
	| requestTracker |

	self
		request: aHttpRequest;
		response: (HttpResponse fromString: '').

	requestTracker := SBRPRequestTracker new.
	requestTracker initRequest: self dynamicEnvironment.
	[ self parseRequestContent: aHttpRequest ]
		on: Error do: [:e | ^ self badRequest ].
	
	requestTracker preRouting: self dynamicEnvironment.
	[ self route: aHttpRequest ]
		on: Error do: [:e | self serverError: e].
	requestTracker postRouting: self dynamicEnvironment.
	
	self logWindow logRequest: aHttpRequest andResponse: self response.
	requestTracker finalizeRequest: self dynamicEnvironment.
	self changed: #requestHandled with: requestTracker.
	^ self response

]

{ #category : #routing }
SBRPApplication >> processRequest: aHttpRequest [

	aHttpRequest url = '/favicon.ico'
		ifTrue: [
			self doProcessRequest: aHttpRequest]
		ifFalse: [ | recorder |
			recorder := MessageSendRecorder new
				watchPackageNamed: #'Sandblocks-RatPack';
				watchPackageNamed: #'Ratpack-Core';
				watchPackageNamed: #'Ratpack-Examples';
				setMessageSend: (MessageSend receiver: self selector: #doProcessRequest: argument: aHttpRequest);
				yourself.
			recorder record.
			recorder topRecord browse].
	
	^ self response

]

{ #category : #'as yet unclassified' }
SBRPApplication >> requestTracker [

	^ self dynamicEnvironment at: #requestTracker
]

{ #category : #'as yet unclassified' }
SBRPApplication >> requestTracker: aSBRPRequestTracker [

	self dynamicEnvironment at: #requestTracker put: aSBRPRequestTracker.
]
