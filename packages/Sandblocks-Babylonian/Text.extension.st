Extension { #name : #Text }

{ #category : #'*Sandblocks-Babylonian' }
Text >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (SBStringMorph new contents: self)
		yourself
]
