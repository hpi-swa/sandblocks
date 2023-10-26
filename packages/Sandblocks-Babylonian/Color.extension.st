Extension { #name : #Color }

{ #category : #'*Sandblocks-Babylonian' }
Color >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [
		
	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorph: (aSBMorphResizer applyOn: self asMorph); 
		yourself
]
