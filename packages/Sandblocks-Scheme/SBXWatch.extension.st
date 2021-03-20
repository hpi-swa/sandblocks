Extension { #name : #SBXWatch }

{ #category : #'*Sandblocks-Scheme' }
SBXWatch >> isScheme [

	^ true
]

{ #category : #'*Sandblocks-Scheme' }
SBXWatch >> writeScmSourceOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self className.
	aStream nextPutAll: ' eval: '.
	aStream store: self root sourceString.
	aStream nextPutAll: ' lang: "'.
	aStream nextPutAll: self language.
	aStream nextPutAll: '")'
]
