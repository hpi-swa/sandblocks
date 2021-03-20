Extension { #name : #SBWatch }

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> writeStSourceOn: aStream [

	aStream nextPutAll: '(SBWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
