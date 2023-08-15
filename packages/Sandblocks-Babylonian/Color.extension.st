Extension { #name : #Color }

{ #category : #'*Sandblocks-Babylonian' }
Color >> sbWatchValueMorphFor: traceValue [
		
	^ (SBWatchValue newContainerMorphFor: traceValue) 
		addMorph: self asMorph; 
		yourself
]
