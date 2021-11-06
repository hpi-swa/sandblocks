Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-CustomJavascript' }
SBLanguageBox >> isJavascript [

	^ true
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBLanguageBox >> isVariable [

	^ false
]

{ #category : #'*Sandblocks-CustomJavascript' }
SBLanguageBox >> writeJsSourceOn: aStream [

	aStream
		nextPutAll: '(evalLang("';
		nextPutAll: self root sourceString;
		nextPutAll: '","';
		nextPutAll: self language;
		nextPutAll: '"))'
]
