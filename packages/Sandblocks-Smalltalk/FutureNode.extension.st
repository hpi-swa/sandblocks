Extension { #name : #FutureNode }

{ #category : #'*Sandblocks-Smalltalk' }
FutureNode >> futureArgs [

	^ futureArgs
]

{ #category : #'*Sandblocks-Smalltalk' }
FutureNode >> printOn: aStream indent: level [

	aStream space; nextPutAll: originalSelector; space; nextPutAll: futureSelector.
	receiver printOn: aStream indent: level
]
