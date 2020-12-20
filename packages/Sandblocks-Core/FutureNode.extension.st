Extension { #name : #FutureNode }

{ #category : #'*Sandblocks-Core' }
FutureNode >> futureArgs [

	^ futureArgs
]

{ #category : #'*Sandblocks-Core' }
FutureNode >> printOn: aStream indent: level [

	aStream space; nextPutAll: originalSelector; space; nextPutAll: futureSelector.
	receiver printOn: aStream indent: level
]
