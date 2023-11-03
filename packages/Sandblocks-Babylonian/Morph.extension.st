Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (SBIcon iconFor: aSBWatchValue watchedValueIdentityHash) asMorph;
		addMorphBack: (aSBMorphResizer applyOn: self sbSnapshot asMorph);
		yourself
]
