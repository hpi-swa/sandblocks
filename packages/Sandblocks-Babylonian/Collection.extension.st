Extension { #name : #Collection }

{ #category : #'*Sandblocks-Babylonian' }
Collection >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorph: (SBStringMorph new contents: (self printStringLimitedTo: 1000));
		yourself
]
