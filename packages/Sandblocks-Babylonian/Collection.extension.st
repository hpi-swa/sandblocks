Extension { #name : #Collection }

{ #category : #'*Sandblocks-Babylonian' }
Collection >> sbWatchValueMorphFor: traceValue [

	^ SBWatchValue newContainerMorph 
		addMorph: (SBStringMorph new contents: self printString)
		yourself
]
