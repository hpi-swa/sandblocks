Extension { #name : #Object }

{ #category : #'*Sandblocks-Babylonian' }
Object >> applyResize: aPoint [

	"Nothing"
]

{ #category : #'*Sandblocks-Babylonian' }
Object >> asSBWatchValue [

	^ SBWatchValue 
		value: self sbSnapshot 
		identityHash: self identityHash
]

{ #category : #'*Sandblocks-Babylonian' }
Object class >> exampleBlock [

	^ (self name, ' new') parseAsSandblock
]

{ #category : #'*Sandblocks-Babylonian' }
Object class >> exampleBlockContainingClass: aClass [

	^ self exampleBlock 
	
	
]

{ #category : #'*Sandblocks-Babylonian' }
Object class >> exampleObject [

	^ self new
]

{ #category : #'*Sandblocks-Babylonian' }
Object class >> exampleObjectContainingClass: aClass [

	"For generic classes to overwrite"
	^ self exampleObject
]

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
Object >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	"This has to return a container block"
	"Objects can choose if they want to apply a changed extent" 
		
	^ (SBWatchValue newContainerMorphFor: aSBWatchValue) 
		"addMorphBack: (SBIcon iconFor: aSBWatchValue watchedValueIdentityHash) asMorph;"
		addMorphBack: self asMorph;
		yourself
]
