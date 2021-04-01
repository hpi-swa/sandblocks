Extension { #name : #SBLanguageBox }

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> guessClassExpensive [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> guessedClass [

	^ nil
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> updatePCFrom: anObject [
]

{ #category : #'*Sandblocks-Smalltalk' }
SBLanguageBox >> writeStSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root prettySourceString.
	aStream nextPutAll: ' lang: '.
	aStream store: self language.
	aStream nextPutAll: ')'
]
