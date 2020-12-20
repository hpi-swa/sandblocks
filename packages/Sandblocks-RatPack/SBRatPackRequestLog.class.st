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

{ #category : #nil }
SBRatPackRequestLog class >> get [

	^ tmp
]

{ #category : #nil }
SBRatPackRequestLog class >> set: sbrprl [

	tmp := sbrprl.
]

{ #category : #'submorphs-add/remove' }
SBRatPackRequestLog >> delete [

	super delete.
	self service removeDependent: self.
]

{ #category : #'as yet unclassified' }
SBRatPackRequestLog >> exploreLatestRequest [

	self requestLog ifNotEmpty: [
		Project current addDeferredUIMessage: [
			"self lastRequest explore"
			self sandblockEditor
				openMorphInView: (SBMorphWrapperBlock new
					addMorphBack: (ToolBuilder build: (ObjectExplorer explore: self lastRequest))
						submorphs third)]].
]

{ #category : #'as yet unclassified' }
SBRatPackRequestLog >> handleRequestTracking: aSBRPRequestTracker [

	(self handlerSelector = aSBRPRequestTracker handler) ifTrue: [
		self requestLog addLast: aSBRPRequestTracker.
		self changed: #lastRequest].
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
		addMorph: (SBStringMorph contents: '<no request yet>');
		addMorphBack: (SBButton new
			label: '<route not requested yet>'
			shortcut: nil
			do: [self exploreLatestRequest];
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
SBRatPackRequestLog >> requestLog [
	^ requestLog
]

{ #category : #accessing }
SBRatPackRequestLog >> requestLog: anSequenceableCollection [
	requestLog := anSequenceableCollection
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
		ifFound: [:server |
			self service: server]
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

	(aSymbol = #lastRequest) ifTrue: [
		self firstSubmorph contents: 'total requests: ', requestLog size.
		self lastSubmorph label: 'last request: "', self lastRequest statusString, '"'].
]

{ #category : #updating }
SBRatPackRequestLog >> update: aSymbol with: anObject [

	(aSymbol = #requestHandled) ifTrue: [
		self handleRequestTracking: anObject].
]
