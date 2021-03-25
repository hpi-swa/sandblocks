Extension { #name : #SBWatch }

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> asStExpression: converter [
	<convert>
	
	converter
		if: [self expression isSmalltalk and: [self grammarHandler notNil]]
		do: [(String streamContents: [:s | self writeStSourceOn: s]) parseAsSandblockWithoutSubstitution]
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> guessedClass [

	^ self expression guessedClass
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> isSmalltalk [

	^ true
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> updatePCFrom: anObject [
]

{ #category : #'*Sandblocks-Smalltalk' }
SBWatch >> writeStSourceOn: aStream [

	aStream nextPutAll: '(SBWatch report: '.
	self expression writeSourceOn: aStream.
	aStream nextPutAll: ' for: '.
	self identifier storeOn: aStream.
	aStream nextPut: $)
]
