Extension { #name : #Number }

{ #category : #'*Sandblocks-Babylonian' }
Number >> sbWatchValueMorphFor: traceValue [

	^ SBWatchValue newContainerMorph 
		addMorphBack:  (SBStringMorph new contents: self printString);
		yourself
]
