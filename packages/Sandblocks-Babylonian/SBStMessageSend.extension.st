Extension { #name : #SBStMessageSend }

{ #category : #'*Sandblocks-Babylonian' }
SBStMessageSend >> suggestedAlternationName [

	^ self isAssignment
		ifTrue: [self receiver suggestedAlternationName]
		ifFalse: ['{1}' format: {self selector}]
]
