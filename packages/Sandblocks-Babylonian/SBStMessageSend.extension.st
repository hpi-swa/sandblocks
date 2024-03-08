Extension { #name : #SBStMessageSend }

{ #category : #'*Sandblocks-Babylonian' }
SBStMessageSend >> suggestedAlternationName [

	^ '{1} to {2}' format: {self selector. self receiver suggestedAlternationName  }
]
