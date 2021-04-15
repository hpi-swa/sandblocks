Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Javascript' }
SBLanguageBox >> isJavascript [

	^ true
]

{ #category : #'*Sandblocks-Javascript' }
SBLanguageBox >> isVariable [

	^ false
]

{ #category : #'*Sandblocks-Javascript' }
SBLanguageBox >> writeJsSourceOn: aStream [

	aStream
		nextPutAll: '(evalLang("';
		nextPutAll: self root sourceString;
		nextPutAll: '","';
		nextPutAll: self language;
		nextPutAll: '"))'
]
