Extension { #name : #String }

{ #category : #'*Sandblocks-Babylonian' }
String >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		addMorphBack: (SBStringMorph new contents: self asText)
		yourself
]
