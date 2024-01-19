Extension { #name : #Form }

{ #category : #'*Sandblocks-Babylonian' }
Form class >> exampleBlock [

	^ 'Form squeakLogo' parseAsSandblock
]

{ #category : #'*Sandblocks-Babylonian' }
Form class >> exampleObject [

	^ self squeakLogo
]

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
