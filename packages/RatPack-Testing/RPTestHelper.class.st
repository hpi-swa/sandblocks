Class {
	#name : #RPTestHelper,
	#superclass : #Object,
	#category : #'RatPack-Testing'
}

{ #category : #'helper functions' }
RPTestHelper class >> check: anObject at: anInstanceName for: aValue [

	[((anObject instVarNamed: anInstanceName) = (aValue))
		ifTrue: [^true]
		ifFalse: [^false] ] 
			on: Error 
			do: [^false]
	
]

{ #category : #'http requests' }
RPTestHelper class >> createObjects: amount of: anRPModel [

	^ (1 to: amount) collect: [:i | anRPModel createObjectFrom: RPTestModel fullObject.] 
]

{ #category : #'http requests' }
RPTestHelper class >> createTestObject [

	^ RPTestModel createObjectFrom: RPTestModel fullObject
]

{ #category : #'http requests' }
RPTestHelper class >> createTestObjects: amount [

	^ (1 to: amount) collect: [:i | RPTestModel createObjectFrom: RPTestModel fullObject.] 
]

{ #category : #'http requests' }
RPTestHelper class >> delete: aUrl on: anApplication [

	^ self delete: aUrl on: anApplication headers: Dictionary new
]

{ #category : #'http requests' }
RPTestHelper class >> delete: aUrl on: anApplication content: aString [

	^ self update: aUrl on: anApplication headers: Dictionary new content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> delete: aUrl on: anApplication headers: aDictionary [

	aDictionary at: 'Accept' ifAbsentPut: '*/*'.
	^ self request: aUrl
		on: anApplication
		method: 'DELETE'
		headers: aDictionary
		content: ''
]

{ #category : #'http requests' }
RPTestHelper class >> delete: aUrl on: anApplication headers: aDictionary content: content [

	| contentType |
	contentType := content isString
						ifTrue: ['application/octet-stream']
						ifFalse: ['application/x-www-form-urlencoded'].
	aDictionary
		at: 'Accept' ifAbsentPut: '*/*';
		at: 'Content-Type' ifAbsentPut: contentType.
	^ self request: aUrl on: anApplication
		method: 'DELETE' headers: aDictionary
		content: content
]

{ #category : #'http requests' }
RPTestHelper class >> get: aUrl on: anApplication [

	^ self get: aUrl on: anApplication headers: Dictionary new
]

{ #category : #'http requests' }
RPTestHelper class >> get: aUrl on: anApplication headers: aDictionary [

	aDictionary at: 'Accept' ifAbsentPut: '*/*'.
	^ self request: aUrl
		on: anApplication
		method: 'GET'
		headers: aDictionary
		content: ''
]

{ #category : #'helper functions' }
RPTestHelper class >> getExampleEnvironment [

	^ RPDynamicEnv newFrom: {#rpRouteHandler ->#handler . #preHookCounter -> 0 . #postHookCounter -> 0 . #rpRequest -> (HttpRequest new url: ''). #rpResponse -> (HttpResponse fromString: '')}
]

{ #category : #'helper functions' }
RPTestHelper class >> getExampleGlobalHeaders [

	^ {'date' -> [ TimeStamp now asString. ] . 'global-headers-work' -> 'true' } asDictionary
]

{ #category : #'http requests' }
RPTestHelper class >> httpRequestFor: aUrl method: aString headers: headers content: content [
	| port rawUrl server rawContent rawHeaders relativeUrl |
	rawUrl := (aUrl startsWith: 'http')
				ifTrue: [aUrl copyFrom: 'http://' size to: aUrl size]
				ifFalse: [aUrl].
	server := rawUrl copyUpTo: $:.
	port := ((rawUrl copyAfter: $:) ifEmpty: ['80']) asNumber.
	relativeUrl := (rawUrl copyAfter: $:)
					ifEmpty: [rawUrl copyFrom: server size + 1 to: rawUrl size]
					ifNotEmptyDo: [:str | str copyFrom: port asString size + 1 to: str size].
	(relativeUrl startsWith: '/') ifFalse: [relativeUrl := '/', relativeUrl].
	rawContent := ''.
	content notNil & content notEmpty ifTrue: [
		rawContent := content isString
					ifTrue: [content]
					ifFalse: [(HTTPSocket argString: content) allButFirst].
		headers at: 'Content-Length' put: rawContent size].
	rawHeaders := String streamContents: [:stream |
		headers keysAndValuesDo: [:key :value |
			stream nextPutAll: key; nextPut: $:; space; nextPutAll: value asString; crlf]].
	^ HttpRequest readFromStream: (
		(ReadWriteStream on: (String new: 100))
			nextPutAll: aString; space; nextPutAll: relativeUrl; nextPutAll: ' HTTP/1.0'; crlf;
			nextPutAll: 'Host: '; nextPutAll: server; nextPut: $:; nextPutAll: port asString; crlf;
			nextPutAll: 'Connection: close'; crlf;
			nextPutAll: 'User-Agent: RatPackMockRequestor'; crlf;
			nextPutAll: rawHeaders; crlf;
			nextPutAll: rawContent; crlf;
			nextPutAll: (rawContent ifNotEmpty: [String crlf]);
			reset;
			yourself)
]

{ #category : #'http requests' }
RPTestHelper class >> insertObjects: objects of: anRPModel into: aDatabase [

	objects do: [:object | aDatabase persist: object from: anRPModel]
]

{ #category : #'http requests' }
RPTestHelper class >> load: anId on: app [

	^ app database loadModelObject: anId from: RPTestModel 
]

{ #category : #'http requests' }
RPTestHelper class >> mockRequestFor: aUrl method: aString headers: headers content: content [
	| rawContent |
	rawContent := ''.
	content notNil & content notEmpty ifTrue: [
		rawContent := content isString
					ifTrue: [content]
					ifFalse: [(HTTPSocket argString: content) allButFirst].
		headers at: 'Content-Length' put: rawContent size].
	^ RPMockRequest method: aString rawUrl: aUrl headers: headers content: rawContent
]

{ #category : #'http requests' }
RPTestHelper class >> persist: objects on: app [

	objects do: [:object | app database persist: object from: RPTestModel]  
]

{ #category : #'http requests' }
RPTestHelper class >> persistNew: amount on: app [

	self persist: (self createTestObjects: amount) on: app.
]

{ #category : #'http requests' }
RPTestHelper class >> post: aUrl on: anApplication content: aString [

	^ self post: aUrl on: anApplication headers: Dictionary new content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> post: aUrl on: anApplication headers: aDictionary content: content [

	| contentType |
	contentType := MIMEDocument contentTypeFormData.
	aDictionary
		at: 'Accept' ifAbsentPut: '*/*';
		at: 'Content-Type' ifAbsentPut: contentType.
	^ self request: aUrl on: anApplication
		method: 'POST' headers: aDictionary
		content: content
]

{ #category : #'http requests' }
RPTestHelper class >> post: aUrl on: anApplication json: aString [

	| headers |
	
	headers := Dictionary newFrom: {'Content-Type' -> 'application/json'}.
	^ self post: aUrl on: anApplication headers: headers content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> put: aUrl on: anApplication content: aString [

	^ self put: aUrl on: anApplication headers: Dictionary new content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> put: aUrl on: anApplication headers: aDictionary content: content [

	| contentType |
	contentType := content isString
						ifTrue: ['application/octet-stream']
						ifFalse: ['application/x-www-form-urlencoded'].
	aDictionary
		at: 'Accept' ifAbsentPut: '*/*';
		at: 'Content-Type' ifAbsentPut: contentType.
	^ self request: aUrl on: anApplication
		method: 'PUT' headers: aDictionary
		content: content
]

{ #category : #'http requests' }
RPTestHelper class >> put: aUrl on: anApplication json: aString [

	| headers |
	
	headers := Dictionary newFrom: {'Content-Type' -> 'application/json'}.
	^ self put: aUrl on: anApplication headers: headers content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> request: aUrl on: anApplication method: aString headers: headers content: content [
	| request |
	request := self mockRequestFor: aUrl method: aString headers: headers content: content.
	^ anApplication processRequest: request
]

{ #category : #'http requests' }
RPTestHelper class >> update: aUrl on: anApplication content: aString [

	^ self update: aUrl on: anApplication headers: Dictionary new content: aString
]

{ #category : #'http requests' }
RPTestHelper class >> update: aUrl on: anApplication headers: aDictionary content: content [

	| contentType |
	contentType := content isString
						ifTrue: ['application/octet-stream']
						ifFalse: ['application/x-www-form-urlencoded'].
	aDictionary
		at: 'Accept' ifAbsentPut: '*/*';
		at: 'Content-Type' ifAbsentPut: contentType.
	^ self request: aUrl on: anApplication
		method: 'UPDATE' headers: aDictionary
		content: content
]
