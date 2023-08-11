Extension { #name : #String }

{ #category : #'*Sandblocks-Babylonian' }
String >> sbWatchValueMorphFor: traceValue [

	^ SBWatchValue newContainerMorph 
		addMorphBack: (SBStringMorph new contents: self asText)
		yourself
]
