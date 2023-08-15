Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: traceValue [

	^ (SBWatchValue newContainerMorphFor: traceValue)  
		addMorphBack: (SBIcon iconFor: traceValue watchedValueIdentityHash) asMorph;
		addMorphBack: self asMorph;
		yourself
]
