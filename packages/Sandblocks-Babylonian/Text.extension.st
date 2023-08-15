Extension { #name : #Text }

{ #category : #'*Sandblocks-Babylonian' }
Text >> sbWatchValueMorphFor: traceValue [

	^ (SBWatchValue newContainerMorphFor: traceValue)  
		addMorphBack: (SBStringMorph new contents: self)
		yourself
]
