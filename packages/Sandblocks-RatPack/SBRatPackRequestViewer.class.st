Class {
	#name : #SBRatPackRequestViewer,
	#superclass : #SBExplorerBlock,
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRatPackRequestViewer class >> newFor: aSBRPRequestAnalytics [

	^ self new
		object: aSBRPRequestAnalytics;
		yourself
]

{ #category : #actions }
SBRatPackRequestViewer >> browseCallStack [

	<action>
	self requestAnalytics routeMessageRecord browse
]

{ #category : #accessing }
SBRatPackRequestViewer >> browseCallStackButton [

	^ self submorphNamed: #browseCallStackButton
]

{ #category : #initialization }
SBRatPackRequestViewer >> buildBody [

	self addMorphBack: (SBStringMorph contents: '[', self statusTitle, '] ', self urlTitle).
	self addMorphBack: (SBButton new
		label: (self handlerTitle, ' ' , self routeTitle)
		shortcut: nil
		do: [self exploreRouteMethod];
		name: #exploreRouteMethodButton;
		yourself).
	super buildBody.
	self addMorphBack: (SBButton new
		label: 'resend this request'
		shortcut: nil
		do: [self resendRequest];
		name: #resendRequestButton;
		yourself).
	self addMorphBack: (SBButton new
		label: 'explore model-object accesses'
		shortcut: nil
		do: [self exploreModelAccesses];
		name: #exploreModelAccessesButton;
		yourself).
	self addMorphBack: (SBButton new
		label: 'browse route call stack (with timings)'
		shortcut: nil
		do: [self browseCallStack];
		name: #browseCallStackButton;
		yourself).
]

{ #category : #actions }
SBRatPackRequestViewer >> exploreModelAccesses [

	<action>
	| records |
	records := self requestAnalytics routeModelMutatorMessageRecords.
	records explore.
]

{ #category : #accessing }
SBRatPackRequestViewer >> exploreModelAccessesButton [

	^ self submorphNamed: #exploreModelAccessesButton
]

{ #category : #actions }
SBRatPackRequestViewer >> exploreRouteMethod [

	<action>
	self sandblockEditor open: self requestAnalytics handlerMethod.
	"TODO: append this request to the request tracker if the SBRatPackRoute is newly created"
]

{ #category : #accessing }
SBRatPackRequestViewer >> exploreRouteMethodButton [

	^ self submorphNamed: #exploreRouteMethodButton
]

{ #category : #accessing }
SBRatPackRequestViewer >> handlerTitle [

	| handler |
	handler := self requestAnalytics handlerMethod.

	^ String streamContents: [:s | handler printReferenceOn: s]
]

{ #category : #initialization }
SBRatPackRequestViewer >> initialize [

	super initialize.
	self extent: 500@240.
	
]

{ #category : #accessing }
SBRatPackRequestViewer >> requestAnalytics [

	^ self object
]

{ #category : #actions }
SBRatPackRequestViewer >> resendRequest [

	<action>
	(WebClient httpGet: self requestAnalytics buildLocalUrl) explore.
	"TODO: open as sandblock"
]

{ #category : #accessing }
SBRatPackRequestViewer >> resendRequestButton [

	^ self submorphNamed: #resendRequestButton
]

{ #category : #accessing }
SBRatPackRequestViewer >> routeTitle [
	| route |
	route := self requestAnalytics handlerRoute.

	^ '(Route: ',
		route key asSimpleGetter asUppercase,
		' ',
		route value,
		')'
]

{ #category : #accessing }
SBRatPackRequestViewer >> service [

	^ self requestAnalytics handlerApp
]

{ #category : #accessing }
SBRatPackRequestViewer >> statusTitle [

	^ self requestAnalytics statusString
]

{ #category : #accessing }
SBRatPackRequestViewer >> urlTitle [

	^ self requestAnalytics url
]

{ #category : #actions }
SBRatPackRequestViewer >> viewResponseContent [

	<action>
	self sandblockEditor openMorphInView: (SBExplorerBlock newFor:
		(self requestAnalytics response contents contents)).
]
