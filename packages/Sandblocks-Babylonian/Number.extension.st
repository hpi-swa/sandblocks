Extension { #name : #Number }

{ #category : #'*Sandblocks-Babylonian' }
Number >> sbWatchValueMorphFor: traceValue [

	^ (SBWatchValue newContainerMorphFor: traceValue)  
		addMorphBack:  (SBStringMorph new contents: self printString);
		yourself
]
