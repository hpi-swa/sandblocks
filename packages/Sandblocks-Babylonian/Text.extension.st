Extension { #name : #Text }

{ #category : #'*Sandblocks-Babylonian' }
Text >> sbWatchValueMorphFor: traceValue [

	^ SBWatchValue newContainerMorph 
		addMorphBack: (SBStringMorph new contents: self)
		yourself
]
