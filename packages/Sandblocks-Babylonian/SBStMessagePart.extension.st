Extension { #name : #SBStMessagePart }

{ #category : #'*Sandblocks-Babylonian' }
SBStMessagePart >> suggestedAlternationName [

	^ self isAssignment
		ifTrue: ['{1} {2}' format: {self receiver. self selector suggestedAlternationName}] 
		ifFalse: [self contents]
]
