Class {
	#name : #SBRatPackRequestLog,
	#superclass : #SBBlock,
	#instVars : [
		'service',
		'handlerSelector',
		'route',
		'requestLog'
	],
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRatPackRequestLog class >> labelNoRequests [

	^ '<no request yet>'
]

{ #category : #'as yet unclassified' }
SBRatPackRequestLog class >> labelRequestCount: anInt [

	^ 'total requests: ', anInt
]

{ #category : #'as yet unclassified' }
SBRatPackRequestLog class >> labelRouteLastRequest: aStatusString [

	^ 'last request: "', aStatusString, '"'
]

{ #category : #'as yet unclassified' }
SBRatPackRequestLog class >> labelRouteNotRequested [

	^ '<route not requested yet>'
]

{ #category : #actions }
SBRatPackRequestLog >> clearRequestLog [

	<action>
	self requestLog: LinkedList new.
	self changed: #requestLog.
]

{ #category : #accessing }
SBRatPackRequestLog >> clearRequestLogButton [

	^ self submorphNamed: #clearRequestLogButton
]

{ #category : #'submorphs-add/remove' }
SBRatPackRequestLog >> delete [

	super delete.
	self service removeDependent: self.
]

{ #category : #actions }
SBRatPackRequestLog >> exploreLatestRequest [

	<action>
	self requestLog ifNotEmpty: [
		Project current addDeferredUIMessage: [
			"self lastRequest explore"
			self sandblockEditor openMorphInView: (SBRatPackRequestViewer newFor: self lastRequest)]].
]

{ #category : #accessing }
SBRatPackRequestLog >> exploreRequestButton [

	^ self submorphNamed: #exploreRequestButton
]

{ #category : #actions }
SBRatPackRequestLog >> exploreRequestLog [

	<action>
	self requestLog explore
]

{ #category : #updating }
SBRatPackRequestLog >> handleRequestTracking: aSBRPRequestAnalytics [

	(self handlerSelector = aSBRPRequestAnalytics handlerSymbol) ifTrue: [
		self requestLog addLast: aSBRPRequestAnalytics.
		self changed: #requestLog].
]

{ #category : #accessing }
SBRatPackRequestLog >> handlerSelector [
	^ handlerSelector
]

{ #category : #accessing }
SBRatPackRequestLog >> handlerSelector: aSelector [
	handlerSelector := aSelector
]

{ #category : #initialization }
SBRatPackRequestLog >> initialize [

	super initialize.
	self requestLog: LinkedList new.
	
	self
		addMorph: ((SBStringMorph contents: self class labelNoRequests)
			name: #requestCountLabel;
			yourself);
		addMorphBack: (SBButton new
			label: (self class labelRouteNotRequested)
			shortcut: nil
			do: [self exploreLatestRequest];
			name: #exploreRequestButton;
			yourself);
		addMorphBack: (SBButton new
			label: 'clear recent requests'
			shortcut: nil
			do: [self clearRequestLog];
			name: #clearRequestLogButton;
			yourself);
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap.
	self addDependent: self.
]

{ #category : #accessing }
SBRatPackRequestLog >> lastRequest [

	^ self requestLog last
]

{ #category : #accessing }
SBRatPackRequestLog >> object [

	^ self lastRequest
]

{ #category : #'submorphs-add/remove' }
SBRatPackRequestLog >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	self service removeDependent: self.
]

{ #category : #accessing }
SBRatPackRequestLog >> requestCountLabel [

	^ self submorphNamed: #requestCountLabel
]

{ #category : #accessing }
SBRatPackRequestLog >> requestLog [
	^ requestLog
]

{ #category : #accessing }
SBRatPackRequestLog >> requestLog: anSequenceableCollection [
	requestLog := anSequenceableCollection
]

{ #category : #actions }
SBRatPackRequestLog >> resendLatestRequest [

	<action>
	(WebClient httpGet: self lastRequest buildLocalUrl) explore.
]

{ #category : #accessing }
SBRatPackRequestLog >> route [
	^ route
]

{ #category : #accessing }
SBRatPackRequestLog >> route: anObject [
	route := anObject
]

{ #category : #accessing }
SBRatPackRequestLog >> serverClass: aRPApplicationClass [

	RPApplication services
		detect: [:s | s class = aRPApplicationClass]
		ifFound: [:server | self service: server]
		ifNone: [self error: 'No running services for this class'].
]

{ #category : #accessing }
SBRatPackRequestLog >> service [
	^ service
]

{ #category : #accessing }
SBRatPackRequestLog >> service: aRPApplication [
	service := aRPApplication.
	aRPApplication addDependent: self.
]

{ #category : #updating }
SBRatPackRequestLog >> update: aSymbol [

	(aSymbol = #requestLog) ifTrue: [
		self requestCountLabel contents:
			(requestLog isEmpty
				ifTrue: [self class labelNoRequests]
				ifFalse: [self class labelRequestCount: requestLog size]).
		self exploreRequestButton label:
			(requestLog isEmpty
				ifTrue: [self class labelRouteNotRequested]
				ifFalse: [self class labelRouteLastRequest: self lastRequest statusString])].
]

{ #category : #updating }
SBRatPackRequestLog >> update: aSymbol with: anObject [

	(aSymbol = #requestHandled) ifTrue: [
		self handleRequestTracking: anObject].
]
