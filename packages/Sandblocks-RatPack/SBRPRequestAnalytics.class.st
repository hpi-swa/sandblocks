Class {
	#name : #SBRPRequestAnalytics,
	#superclass : #Dictionary,
	#category : #'Sandblocks-RatPack'
}

{ #category : #utils }
SBRPRequestAnalytics >> appModels [

	^ self handlerApp modelClasses values
		collect: [ :modelClass | modelClass refClass ]
]

{ #category : #utils }
SBRPRequestAnalytics >> buildLocalUrl [

	^ 'http://localhost:', self handlerApp portNumber asString, self url
]

{ #category : #utils }
SBRPRequestAnalytics >> currentTimestamp [

	^ Time highResClock
]

{ #category : #analytics }
SBRPRequestAnalytics >> finalizeRequest: aSBRPApplication [

	self finalizeRequest: aSBRPApplication with: Dictionary new.
]

{ #category : #analytics }
SBRPRequestAnalytics >> finalizeRequest: aSBRPApplication with: aCollection [
	| dynEnv |
	dynEnv := aSBRPApplication dynamicEnvironment.

	self timingsDict
		add: #postAnalytics -> (self currentTimestamp).
	self at: #extensions put: aCollection asDictionary.
	self handlerDict
		at: #method put: (self handlerApp class
			compiledMethodAt: self handlerSymbol
			ifAbsent: [nil]).
]

{ #category : #accessing }
SBRPRequestAnalytics >> handlerApp [

	^ self handlerDict at: #app
]

{ #category : #accessing }
SBRPRequestAnalytics >> handlerDict [

	^ self at: #handler
]

{ #category : #accessing }
SBRPRequestAnalytics >> handlerMethod [

	^ self handlerDict at: #method
]

{ #category : #accessing }
SBRPRequestAnalytics >> handlerRoute [

	^ SBRatPackRoute findRouteDescribtion: self handlerMethod
]

{ #category : #accessing }
SBRPRequestAnalytics >> handlerSymbol [

	^ self handlerDict at: #symbol
]

{ #category : #analytics }
SBRPRequestAnalytics >> initRequest: aSBRPApplication [
	| dynEnv |
	dynEnv := aSBRPApplication dynamicEnvironment.

	self
		at: #timings put: (OrderedCollection
			with: #preParsing -> (self currentTimestamp));
		at: #request put: dynEnv request;
		at: #response put: dynEnv response;
		at: #handler put: (Dictionary
			newFrom: { #app -> aSBRPApplication }).

]

{ #category : #accessing }
SBRPRequestAnalytics >> messageRecords [

	^ (self
		at: #extensions
		ifAbsent: [ ^nil ])
			at: #messageRecords
			ifAbsent: [ ^nil ]
]

{ #category : #analytics }
SBRPRequestAnalytics >> postRouting: aSBRPApplication [
	| dynEnv |
	dynEnv := aSBRPApplication dynamicEnvironment.

	self timingsDict
		add: #postRouting -> (self currentTimestamp).
	self handlerDict
		at: #symbol put: dynEnv handler.

]

{ #category : #analytics }
SBRPRequestAnalytics >> preRouting: aSBRPApplication [
	| dynEnv |
	dynEnv := aSBRPApplication dynamicEnvironment.

	self timingsDict
		add: #preRouting -> (self currentTimestamp).

]

{ #category : #accessing }
SBRPRequestAnalytics >> request [

	^ self at: #request
]

{ #category : #accessing }
SBRPRequestAnalytics >> requestMethod [

	^ self request propertyAt: #method
]

{ #category : #accessing }
SBRPRequestAnalytics >> response [

	^ self at: #response
]

{ #category : #'accessing-MessageRecords' }
SBRPRequestAnalytics >> routeMessageRecord [

	^ self messageRecords
		detect: [:record | record method selector = self handlerSymbol]
]

{ #category : #'accessing-MessageRecords' }
SBRPRequestAnalytics >> routeModelAccessMessageRecords [

	^ self routeObjectAccessMessageRecords: self appModels

]

{ #category : #'accessing-MessageRecords' }
SBRPRequestAnalytics >> routeModelMutatorMessageRecords [

	^ self routeObjectMutatorMessageRecords: self appModels

]

{ #category : #'accessing-MessageRecords' }
SBRPRequestAnalytics >> routeObjectAccessMessageRecords: aClassCollection [
	| modelAccessDict |
	
	modelAccessDict := Dictionary new: aClassCollection size.
	aClassCollection do: [:clazz |
		modelAccessDict at: clazz put: IdentityDictionary new].
	self routeMessageRecord do: [:record |
		aClassCollection
			detect: [:clazz | clazz = record receiverClass]
			ifFound: [:clazz | ((modelAccessDict at: clazz)
				at: record getReceiver 
				ifAbsentPut: [OrderedCollection new])
					add: record]].
	^ modelAccessDict select: [:modelObjects | modelObjects isEmpty not]

]

{ #category : #'accessing-MessageRecords' }
SBRPRequestAnalytics >> routeObjectMutatorMessageRecords: aClassCollection [

	^ ((self routeObjectAccessMessageRecords: aClassCollection)
		associations
		collect: [:assoc | | modelClass messageRecordsMap instVarMutators |
			modelClass := assoc key.
			instVarMutators := modelClass instVarNames gather: [:instVarName | {
				instVarName asSimpleGetter.
				instVarName asSimpleSetter}].
			messageRecordsMap := assoc value
				collect: [:messageRecords | messageRecords
					select: [:record | instVarMutators includes: record selector]].
			modelClass -> (messageRecordsMap
				select: [:messageRecords | messageRecords isEmpty not]) associations])
		asDictionary

]

{ #category : #accessing }
SBRPRequestAnalytics >> statusCode [

	^ self response statusCode
]

{ #category : #accessing }
SBRPRequestAnalytics >> statusString [

	^ self requestMethod, ' ', self statusCode, ' ', self response status asUppercase
]

{ #category : #accessing }
SBRPRequestAnalytics >> timingsDict [

	^ self at: #timings
]

{ #category : #accessing }
SBRPRequestAnalytics >> url [

	^ self request rawUrl "or url"
]
