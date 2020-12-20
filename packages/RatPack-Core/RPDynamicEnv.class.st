Class {
	#name : #RPDynamicEnv,
	#superclass : #IdentityDictionary,
	#category : #'RatPack-Core'
}

{ #category : #constants }
RPDynamicEnv class >> parsedRequestArgumentsKey [
	
	^ #rpParsedRequestArguments
]

{ #category : #constants }
RPDynamicEnv class >> parsedRequestContentsKey [
	
	^ #rpParsedRequestContents
]

{ #category : #constants }
RPDynamicEnv class >> requestKey [

	^ #rpRequest
]

{ #category : #constants }
RPDynamicEnv class >> responseKey [

	^ #rpResponse
]

{ #category : #constants }
RPDynamicEnv class >> routeHandlerKey [

	^ #rpRouteHandler
]

{ #category : #constants }
RPDynamicEnv class >> sessionKey [
	
	^ #rpSession
]

{ #category : #constants }
RPDynamicEnv class >> settingsKey [

	^ #rpSettings
]

{ #category : #accessing }
RPDynamicEnv >> addCookies: aCollectionOrBlock [
	
	^ self response addCookies: (aCollectionOrBlock value)
]

{ #category : #accessing }
RPDynamicEnv >> body [
	"The first contents is a stream, we want a string"
	^ self response contents contents

]

{ #category : #accessing }
RPDynamicEnv >> body: aStringOrStream [

	self response contents:  aStringOrStream.
]

{ #category : #accessing }
RPDynamicEnv >> contentLength [

	^ self response contentLength
]

{ #category : #accessing }
RPDynamicEnv >> contentType [

	^ self response contentType
]

{ #category : #accessing }
RPDynamicEnv >> contentType: aStringOrBlock [

	self response contentType: (aStringOrBlock value).
]

{ #category : #accessing }
RPDynamicEnv >> cookies [
	
	^ self response cookies
]

{ #category : #accessing }
RPDynamicEnv >> handler [
	
	^ self at: self class routeHandlerKey
]

{ #category : #accessing }
RPDynamicEnv >> handler: aValue [
	
	self at: self class routeHandlerKey put: aValue.
]

{ #category : #accessing }
RPDynamicEnv >> headers [

	^ self response fields
]

{ #category : #accessing }
RPDynamicEnv >> headersAt: aKey [

	^ self response fieldAt: aKey asLowercase
]

{ #category : #accessing }
RPDynamicEnv >> headersAt: aKey ifAbsent: aBlock [

	^ self response fieldAt: aKey asLowercase ifAbsent: aBlock
]

{ #category : #accessing }
RPDynamicEnv >> headersAt: aKey put:	aValueOrBlock [

	| caseInsensitiveKey convinienceHeaders|
	convinienceHeaders :=	{'status' -> [ self status: aValueOrBlock value. ].
				  			'content-type' -> [ self contentType: aValueOrBlock value. ].
				  			'cookies' -> [ self addCookies: aValueOrBlock value. ]} asDictionary.
	
	caseInsensitiveKey := aKey asLowercase.
	convinienceHeaders
		at: caseInsensitiveKey
		ifPresent: [ (convinienceHeaders at: caseInsensitiveKey) value. ]
		ifAbsent: [ self response fieldAt: caseInsensitiveKey put: (aValueOrBlock value). ].
	
]

{ #category : #accessing }
RPDynamicEnv >> headersPut: aDictionary [
 			
	aDictionary
		associationsDo: [ :association | self headersAt: association key put: association value. ].
]

{ #category : #accessing }
RPDynamicEnv >> parsedRequestArguments [

	^ self at: self class parsedRequestArgumentsKey
]

{ #category : #accessing }
RPDynamicEnv >> parsedRequestArguments: aValue [

	self at: self class parsedRequestArgumentsKey put: aValue.
]

{ #category : #accessing }
RPDynamicEnv >> parsedRequestContents [

	^ self at: self class parsedRequestContentsKey
]

{ #category : #accessing }
RPDynamicEnv >> parsedRequestContents: aValue [

	self at: self class parsedRequestContentsKey put: aValue.
]

{ #category : #accessing }
RPDynamicEnv >> request [
	
	^ self at: self class requestKey
]

{ #category : #accessing }
RPDynamicEnv >> request: aHttpRequest [
	
	self at: self class requestKey put: aHttpRequest.
]

{ #category : #accessing }
RPDynamicEnv >> response [
	
	^ self at: self class responseKey
]

{ #category : #accessing }
RPDynamicEnv >> response: aHttpResponse [
	
	self at: self class responseKey put: aHttpResponse.
]

{ #category : #accessing }
RPDynamicEnv >> session [

	^ self at: self class sessionKey
]

{ #category : #accessing }
RPDynamicEnv >> session: aValue [

	self at: self class sessionKey put: aValue.
]

{ #category : #accessing }
RPDynamicEnv >> settings [
	
	^ self at: self class settingsKey
]

{ #category : #accessing }
RPDynamicEnv >> settings: aSettingsObject [
	
	self at: self class settingsKey put: aSettingsObject.
]

{ #category : #accessing }
RPDynamicEnv >> status [
	
	^ self response statusCode asInteger
]

{ #category : #accessing }
RPDynamicEnv >> status: aSymbolOrIntegerOrBlock [

	| evaluatedStatus |
	evaluatedStatus := aSymbolOrIntegerOrBlock value.
	self response status: (evaluatedStatus isSymbol
		ifTrue: [evaluatedStatus]
		ifFalse: [HttpResponse statusSymbolFor: evaluatedStatus]).

]
