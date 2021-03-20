Extension { #name : #SBWatch }

{ #category : #'*Sandblocks-Scheme' }
SBWatch >> isScheme [

	^ true
]

{ #category : #'*Sandblocks-Scheme' }
SBWatch >> writeScmSourceOn: aStream [

	aStream nextPutAll: '(perform SBWatch ''report:for: '.
	self expression writeSourceOn: aStream.
	aStream space.
	aStream nextPutAll: self identifier asString.
	aStream nextPutAll: ')'
]
