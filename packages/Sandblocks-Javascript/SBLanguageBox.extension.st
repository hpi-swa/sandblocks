Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Javascript' }
SBLanguageBox >> isJavascript [

	^ true
]

{ #category : #'*Sandblocks-Javascript' }
SBLanguageBox >> writeJsSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: '.
	aStream nextPutAll: self language.
	aStream nextPutAll: ')'
]
