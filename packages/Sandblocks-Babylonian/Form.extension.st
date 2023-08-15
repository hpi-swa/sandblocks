Extension { #name : #Form }

{ #category : #'*Sandblocks-Babylonian' }
Form >> sbSnapshot [

	^ self copy
]

{ #category : #'*Sandblocks-Babylonian' }
Form >> sbWatchValueMorphFor: traceValue [
		
	^ (SBWatchValue newContainerMorphFor: traceValue)  
		addMorphBack: (SBIcon iconFor: traceValue watchedValueIdentityHash) asMorph;
		addMorphBack: self asMorph;
		yourself
]
