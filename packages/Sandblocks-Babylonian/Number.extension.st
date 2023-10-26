Extension { #name : #Number }

{ #category : #'*Sandblocks-Babylonian' }
Number >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack:  (SBStringMorph new contents: self printString);
		yourself
]
