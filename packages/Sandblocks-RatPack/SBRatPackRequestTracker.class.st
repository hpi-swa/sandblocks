Class {
	#name : #SBRatPackRequestTracker,
	#superclass : #SBBlock,
	#instVars : [
		'service'
	],
	#category : #'Sandblocks-RatPack'
}

{ #category : #'as yet unclassified' }
SBRatPackRequestTracker >> initialize [

	super initialize.
	
	self
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBButton new label: 'Test Request' shortcut: nil do: [self testRequest]);
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBRatPackRequestTracker >> serverClass: aClass [

	RPApplication services
		detect: [:s | s class = aClass]
		ifFound: [:s |
			service := s.
			self addMorphFront: (SBStringMorph new contents: service name)]
		ifNone: [self error: 'No running services for this class']
]

{ #category : #'as yet unclassified' }
SBRatPackRequestTracker >> testRequest [

	| route |
	route := (service routesFor: #get:) first.
	WebClient httpGet: ('http://localhost:', service portNumber asString), route key
]
