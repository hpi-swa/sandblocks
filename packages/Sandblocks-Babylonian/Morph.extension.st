Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: traceValue [

	^ SBWatchValue newContainerMorph 
		addMorphBack: (SBIcon iconFor: traceValue watchedValueIdentityHash) asMorph;
		addMorphBack: self asMorph;
		yourself
]
