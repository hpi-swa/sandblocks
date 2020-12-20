Class {
	#name : #RPSessionMiddleware,
	#superclass : #RPMiddleware,
	#instVars : [
		'createHeader',
		'siganture',
		'signature'
	],
	#category : #'RatPack-Core'
}

{ #category : #interaction }
RPSessionMiddleware >> createHeader [ 

	^ '{"alg":"HS256","typ":"JWT"}'
	
]

{ #category : #interaction }
RPSessionMiddleware >> createPayload: anEnv [

	^ anEnv session asJsonString
]

{ #category : #interaction }
RPSessionMiddleware >> createSignature: aMessage withEnv: anEnv [

	^ (SHA256 new hmac)
	 	key: (self secret: anEnv) asByteArray;
		digestMessage: aMessage asByteArray
]

{ #category : #interaction }
RPSessionMiddleware >> createToken: anEnv [

	| signature header payload message |
	header :=  self createHeader base64UrlEncoded.
	payload := (self createPayload: anEnv) base64UrlEncoded.
	
	message := header , '.' , payload.
	
	signature := (self createSignature: message withEnv: anEnv) base64UrlEncoded.
	
	^ message , '.' , signature
]

{ #category : #accessing }
RPSessionMiddleware >> postHook: anEnv [
	
	| token |
	token := self createToken: anEnv.
	anEnv addCookies: {'authorization=',token} asCollection.
	
	
	
]

{ #category : #accessing }
RPSessionMiddleware >> preHook: anEnv [

	| token |

	anEnv session: JsonObject new.
	token := (anEnv request cookies) at: #authorization ifAbsent: [ ^ true ].
	(self validateToken: token withEnv: anEnv) ifFalse: [ ^ true ].
	[ anEnv session: (self tokenPayload: token). ] on: Error do: [ ^ true ].
	
	
]

{ #category : #interaction }
RPSessionMiddleware >> secret: anEnv [

	^ anEnv settings sessionSecret
]

{ #category : #interaction }
RPSessionMiddleware >> tokenPayload: token [

	| separatedToken |
	separatedToken := token subStrings: '.'.
	
	^ (RPJsonContentParser parse: separatedToken second base64UrlDecoded)
											
]

{ #category : #interaction }
RPSessionMiddleware >> validateToken: token withEnv: anEnv [

	| separatedToken expectedSignature  |
	separatedToken := token subStrings: '.'.

	expectedSignature := (self createSignature:  (separatedToken first , '.' , separatedToken second) withEnv: anEnv ) base64UrlEncoded.

	^  expectedSignature = separatedToken third
	
	
	
	
]
