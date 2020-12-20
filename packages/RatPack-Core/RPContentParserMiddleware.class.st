Class {
	#name : #RPContentParserMiddleware,
	#superclass : #RPMiddleware,
	#category : #'RatPack-Core'
}

{ #category : #private }
RPContentParserMiddleware >> getParserForRequest: aRequest fromParsers: aParserCollection [

	^ aParserCollection at: (aRequest contentType asLowercase) ifAbsent: [^ self error: 'Parser missing']
]

{ #category : #interaction }
RPContentParserMiddleware >> preHook: anEnvironment [
	
	| request parser |
	request := anEnvironment request.
	
	[
		(self shouldProcessRequest: request)
		ifTrue: [
			parser := self getParserForRequest: request fromParsers: anEnvironment settings contentParsers.
			anEnvironment parsedRequestContents: (parser parse: request rawRequestContents).
		]
	] on: Error do: [ :sig |
		anEnvironment parsedRequestContents: nil.
		anEnvironment settings forceCorrectContentDecoding ifTrue: [ ^ sig pass ] ifFalse: [ ^ sig return ] ].
	
	^ true
]

{ #category : #private }
RPContentParserMiddleware >> shouldProcessRequest: aRequest [

	| method |

	method := aRequest method asLowercase asSymbol.
	
	(method = #put) ifTrue: [ ^ true ].
	(method = #post) ifTrue: [ ^ true ].
	
	^ false
]
