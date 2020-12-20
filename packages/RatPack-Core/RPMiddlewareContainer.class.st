Class {
	#name : #RPMiddlewareContainer,
	#superclass : #Object,
	#instVars : [
		'settings',
		'symbolsForHandler',
		'instances'
	],
	#category : #'RatPack-Core'
}

{ #category : #'private-accessing' }
RPMiddlewareContainer >> atHandler: aSymbol [
	
	| list |
	list := self symbolsForHandler at: aSymbol ifAbsentPut: [ #(#globalMiddleware) asOrderedCollection ].
	^ self includeGlobalMiddleware: list
]

{ #category : #'private-interaction' }
RPMiddlewareContainer >> createInstanceFromSymbol: aSymbol [

	^ ( self class environment classNamed: aSymbol ) new
]

{ #category : #'private-accessing' }
RPMiddlewareContainer >> globalMiddleware [

	^ self settings globalMiddleware
]

{ #category : #'private-accessing' }
RPMiddlewareContainer >> globalMiddlewareKey [

	^ self settings globalMiddlewareKey
]

{ #category : #'private-interaction' }
RPMiddlewareContainer >> includeGlobalMiddleware: aMiddlewareList [

	| expandedList listWithGlobalSymbol indexGlobalKey|

	listWithGlobalSymbol := aMiddlewareList copy.
	indexGlobalKey := aMiddlewareList indexOf: #globalMiddleware ifAbsent: [ 	listWithGlobalSymbol add: #globalMiddleware beforeIndex: 1. indexGlobalKey := 1].
	expandedList := listWithGlobalSymbol copyFrom: 1 to: (indexGlobalKey - 1).
	expandedList addAllLast: self globalMiddleware.
	expandedList addAllLast: (listWithGlobalSymbol copyFrom: indexGlobalKey +1 to: listWithGlobalSymbol size). 
	
	^ expandedList 
]

{ #category : #'private-accessing' }
RPMiddlewareContainer >> instanceForName: aSymbol [

	^ self instances at: aSymbol ifAbsentPut: (self createInstanceFromSymbol: aSymbol)
]

{ #category : #'private-accessing' }
RPMiddlewareContainer >> instances [

	^ instances ifNil: [ instances := Dictionary new. ]
]

{ #category : #accessing }
RPMiddlewareContainer >> instancesForHandler: aSymbol [

	^ (self atHandler: aSymbol) collect: [ :middlewareSymbol | self instanceForName: middlewareSymbol ]
]

{ #category : #accessing }
RPMiddlewareContainer >> registerMiddleware: aMiddlewareList forHandler: aSymbol [
	
	self symbolsForHandler at: aSymbol ifPresent: [ self error: 'Changing Middleware at runtime is prohibited.' ].
	^ self symbolsForHandler at: aSymbol ifAbsentPut: aMiddlewareList
]

{ #category : #accessing }
RPMiddlewareContainer >> settings [

	^ settings
]

{ #category : #accessing }
RPMiddlewareContainer >> settings: aRPSettings [

	settings := aRPSettings
]

{ #category : #'private-accessing' }
RPMiddlewareContainer >> symbolsForHandler [

	^ symbolsForHandler ifNil: [ symbolsForHandler := Dictionary new. ]
]
