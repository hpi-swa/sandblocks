Extension { #name : #Color }

{ #category : #'*Sandblocks-Babylonian' }
Color class >> exampleBlock [

	^ self exampleObject asSandblock 
]

{ #category : #'*Sandblocks-Babylonian' }
Color class >> exampleObject [

	^ self random
]

{ #category : #'*Sandblocks-Babylonian' }
Color >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [
		
	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorph: (aSBMorphResizer applyOn: self asMorph); 
		yourself
]
