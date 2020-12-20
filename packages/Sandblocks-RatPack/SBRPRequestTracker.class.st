Class {
	#name : #SBRPRequestTracker,
	#superclass : #Dictionary,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> finalizeRequest: dynEnv [

	"self halt."

]

{ #category : #accessing }
SBRPRequestTracker >> handler [

	^ self at: #handler
]

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> initRequest: dynEnv [

	self
		at: #timings put: (Dictionary new
			at: #preParsing put: Time utcMicrosecondClock;
			yourself);
		at: #request put: dynEnv request;
		at: #response put: dynEnv response.

]

{ #category : #accessing }
SBRPRequestTracker >> lastRequest [
	^ lastRequest
]

{ #category : #accessing }
SBRPRequestTracker >> lastRequest: aDictionary [
	lastRequest := aDictionary
]

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> postRouting: dynEnv [

	(self at: #timings)
		at: #postRouting put: Time utcMicrosecondClock.
	self at: #handler put: dynEnv handler.

]

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> preRouting: dynEnv [

	(self at: #timings)
		at: #preRouting put: Time utcMicrosecondClock.

]

{ #category : #accessing }
SBRPRequestTracker >> request [

	^ self at: #request
]

{ #category : #accessing }
SBRPRequestTracker >> response [

	^ self at: #response
]

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> startRequest: dynEnv [

	self lastRequest: (Dictionary new
		at: #timings put: (Dictionary new
			at: #preParsing put: Time utcMicrosecondClock;
			yourself);
		at: #request put: dynEnv request;
		at: #response put: dynEnv response;
		yourself).

]

{ #category : #'as yet unclassified' }
SBRPRequestTracker >> startRouting: dynEnv [

	(self lastRequest at: #timings)
		at: #preRouting put: Time utcMicrosecondClock.

]

{ #category : #accessing }
SBRPRequestTracker >> statusCode [

	^ self response statusCode
]

{ #category : #accessing }
SBRPRequestTracker >> statusString [

	^ self statusCode, ' ', self response status asUppercase
]

{ #category : #accessing }
SBRPRequestTracker >> timings [

	^ self at: #timings
]
