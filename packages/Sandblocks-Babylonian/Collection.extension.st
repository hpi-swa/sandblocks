Extension { #name : #Collection }

{ #category : #'*Sandblocks-Babylonian' }
Collection >> sbWatchValueMorphFor: traceValue [

	^ (SBWatchValue newContainerMorphFor: traceValue) 
		addMorph: (SBStringMorph new contents: self printString)
		yourself
]
