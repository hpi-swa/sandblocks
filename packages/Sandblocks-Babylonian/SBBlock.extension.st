Extension { #name : #SBBlock }

{ #category : #'*Sandblocks-Babylonian' }
SBBlock >> isExampleWatch [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBBlock >> isGlobalWatch [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBBlock >> isMorphExample [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBBlock >> listensToExamples [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBBlock >> suggestedAlternationName [

	^ self printString
]
