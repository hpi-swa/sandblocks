Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> guessedClass [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> writeStSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: '.
	aStream nextPutAll: self language.
	aStream nextPutAll: ')'
]
