Extension { #name : #Point }

{ #category : #'*Sandblocks-Babylonian' }
Point class >> exampleBlock [

	^ self exampleObject asSandblock 
]

{ #category : #'*Sandblocks-Babylonian' }
Point class >> exampleObject [

	^ self x: Integer exampleObject  y: Integer exampleObject 
]

{ #category : #'*Sandblocks-Babylonian' }
Point >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorphBack: self asMorph;
		yourself
]
