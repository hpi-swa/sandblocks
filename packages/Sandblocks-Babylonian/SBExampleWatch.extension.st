Extension { #name : #SBExampleWatch }

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> isExampleWatch [

	^ true
]

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> isGlobalWatch [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBExampleWatch >> listensToExamples [

	^ self isActive 
]
