Extension { #name : #SBStMessageSend }

{ #category : #'*Sandblocks-Babylonian' }
SBStMessageSend >> suggestedAlternationName [

	^ self isAssignment 
		ifTrue: ['{2}{1}' format: {self selector. self receiver suggestedAlternationName  }] 
		ifFalse: ['{1} to {2}' format: {self selector. self receiver suggestedAlternationName  }] 
]
