Extension { #name : #Object }

{ #category : #'*Sandblocks-Babylonian' }
Object >> sbSnapshot [

	"This is a copy of veryDeepCopy which skips fixDependents as it is currently of minor importance 
	and takes a lot of time."

	| copier new |
	copier := DeepCopier new: self initialDeepCopierSize.
	new := self veryDeepCopyWith: copier.
	copier mapUniClasses.
	copier references associationsDo: [:assoc | 
		assoc value veryDeepFixupWith: copier].
	^ new
]

{ #category : #'*Sandblocks-Babylonian' }
Object >> sbWatchValueMorphFor: traceValue [

	"This has to return a container block"
		
	^ (SBWatchValue newContainerMorphFor: traceValue) 
		addMorphBack: (SBIcon iconFor: traceValue watchedValueIdentityHash) asMorph;
		addMorphBack: (SBStringMorph new contents: (' ' , self printString));
		yourself
]
