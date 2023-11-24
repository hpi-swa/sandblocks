Extension { #name : #Form }

{ #category : #'*Sandblocks-Babylonian' }
Form >> sbSnapshot [

	^ self copy
]

{ #category : #'*Sandblocks-Babylonian' }
Form >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [
		
	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (aSBMorphResizer applyOn: self asMorph);
		yourself
]
