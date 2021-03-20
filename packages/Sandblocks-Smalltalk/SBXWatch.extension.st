Extension { #name : #SBXWatch }

{ #category : #'*Sandblocks-Smalltalk' }
SBXWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'*Sandblocks-Smalltalk' }
SBXWatch >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBXWatch >> writeStSourceOn: aStream [

	aStream nextPutAll: '(SBWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
