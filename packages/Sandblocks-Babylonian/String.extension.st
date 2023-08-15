Extension { #name : #String }

{ #category : #'*Sandblocks-Babylonian' }
String >> sbWatchValueMorphFor: traceValue [

	^ (SBWatchValue newContainerMorphFor: traceValue) 
		addMorphBack: (SBStringMorph new contents: self asText)
		yourself
]
