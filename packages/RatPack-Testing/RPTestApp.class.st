Class {
	#name : #RPTestApp,
	#superclass : #RPApplication,
	#instVars : [
		'indexHandlerCalled'
	],
	#category : #'RatPack-Testing'
}

{ #category : #'as yet unclassified' }
RPTestApp class >> appName [

	^ 'a RPTestApp' 
]

{ #category : #routes }
RPTestApp >> blacklistedHandler [
	<get: '/blacklistTest'>
	<middleware: #(#RPTestMiddleware) >
]

{ #category : #routes }
RPTestApp >> handleRequestForAutoGlobalMiddleware [
	
	<get: '/autoGlobalMiddleware'>
	<middleware: #(#RPWordCountMiddleware #RPUppercaseMiddleware) >
]

{ #category : #routes }
RPTestApp >> handleRequestForCaptureGroupsWithNumber: aNumber andWord: aWord [
	<get: '/captureGroups/number/(\d+)/word/(\w+)'>

	self dynamicEnvironment at: #number put: aNumber asNumber.
	self dynamicEnvironment at: #word put: aWord.
]

{ #category : #routes }
RPTestApp >> handleRequestForChainOrder [
	
	<get: '/chainOrder'>
	<middleware: #(#RPWordCountMiddleware #globalMiddleware #RPUppercaseMiddleware) >
]

{ #category : #routes }
RPTestApp >> handleRequestForIndex [
	<get: '/index'>
	<put: '/index'>
	<post: '/index'>
	
	indexHandlerCalled := true.
	
	^ 'Hello World'
]

{ #category : #routes }
RPTestApp >> handleRequestForManySlashes [
	<get: '/thisDoesExist/butDoesntTakeArguments/even/with/many/Slashes'>
	
]

{ #category : #routes }
RPTestApp >> handleRequestForRedirect [
	<get: '/redirect'>
	^ self redirectTo: '/index'
]

{ #category : #routes }
RPTestApp >> handleRequestForSetHeaders [
	<get: '/setHeaders'>
	
	self contentType: 'application/json'.
	self headersAt: 'handler-headers-work' put: 'true'.
	self addCookies: {'TestCookie'} asOrderedCollection.
]

{ #category : #routes }
RPTestApp >> handleRequestForSimpleJSON [
	<get: '/simpleJSON'>	
	| tmp |
	"Change if objects are finished! Change Test too!!!!"
	tmp := '{"Name":"Test","Port":"1111","Users":["me","you"],"Text":{"Header":"testheader", "Content":"blabla"},"value":30,"finished":true}'.
	^ self sendJson: tmp
]

{ #category : #routes }
RPTestApp >> handleRequestForStopped [
	
	<get: '/stopped'>
	<middleware: #(#RPStoppingMiddleware) >
	
	indexHandlerCalled := true.

]

{ #category : #routes }
RPTestApp >> indexHandlerCalled [ 

	indexHandlerCalled
		ifTrue: [ indexHandlerCalled := false. ^ true ]
		ifFalse: [ ^ false ]
]

{ #category : #'initialize-release' }
RPTestApp >> initialize [ 

	super initialize.
	
	indexHandlerCalled := false.
	self settings globalHeaders: RPTestHelper getExampleGlobalHeaders.
]

{ #category : #'initialize-release' }
RPTestApp >> initializeSettings [
	self settings
		contentParsers: (Dictionary newFrom: {'test/contenttype' -> RPMockParser . 'application/json' -> RPJsonContentParser});
		globalMiddleware: {#RPSessionMiddleware . #RPTestMiddleware. #RPGlobalHeaderMiddleware. #RPContentParserMiddleware} asOrderedCollection;
		routeNamingStrategies: {RPTestRouteNamingStrategy new} asOrderedCollection;
		sessionSecret: '12345'.
]

{ #category : #routes }
RPTestApp >> raiseError [
	<get: '/raiseError'>
	self error: 'This is my error'
]
