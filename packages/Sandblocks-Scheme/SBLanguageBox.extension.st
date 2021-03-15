Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Scheme' }
SBLanguageBox >> isScheme [

	^ true
]

{ #category : #'*Sandblocks-Scheme' }
SBLanguageBox >> writeScmSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: '.
	aStream nextPutAll: self language.
	aStream nextPutAll: ')'
]
