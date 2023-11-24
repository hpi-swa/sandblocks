Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (aSBMorphResizer applyOn: self sbSnapshot asMorph);
		yourself
]
