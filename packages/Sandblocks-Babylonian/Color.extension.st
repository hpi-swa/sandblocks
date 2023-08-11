Extension { #name : #Color }

{ #category : #'*Sandblocks-Babylonian' }
Color >> sbWatchValueMorphFor: traceValue [
		
	^ SBWatchValue newContainerMorph 
		addMorph: self asMorph; 
		yourself
]
