Class {
	#name : #SBRPApplication,
	#superclass : #RPApplication,
	#category : #'Sandblocks-RatPack'
}

{ #category : #routing }
SBRPApplication >> processRequest: aHttpRequest [
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

{ #category : #'as yet unclassified' }
SBRPApplication >> requestTracker [

	^ self dynamicEnvironment at: #requestTracker
]

{ #category : #'as yet unclassified' }
SBRPApplication >> requestTracker: aSBRPRequestTracker [

	self dynamicEnvironment at: #requestTracker put: aSBRPRequestTracker.
]
