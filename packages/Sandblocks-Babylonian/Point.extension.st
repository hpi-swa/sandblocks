Extension { #name : #Point }

{ #category : #'*Sandblocks-Babylonian' }
Point >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorphBack: self asMorph;
		yourself
]
