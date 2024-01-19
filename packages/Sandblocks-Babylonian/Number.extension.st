Extension { #name : #Number }

{ #category : #'*Sandblocks-Babylonian' }
Number class >> exampleBlock [

	^ self exampleObject asSandblock 
]

{ #category : #'*Sandblocks-Babylonian' }
Number class >> exampleObject [

	^ Random new nextInt: 100
]

{ #category : #'*Sandblocks-Babylonian' }
Number >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack:  (SBStringMorph new contents: self printString);
		yourself
]
