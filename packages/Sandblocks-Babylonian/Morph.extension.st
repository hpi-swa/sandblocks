Extension { #name : #Morph }

{ #category : #'*Sandblocks-Babylonian' }
Morph >> applyResize: aPoint [

	^ self extent: aPoint
]

{ #category : #'*Sandblocks-Babylonian' }
Morph class >> exampleObject [

	^ self new
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> listensToPermutations [ 

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> sbWatchValueMorphFor: aSBWatchValue sized: aSBMorphResizer [

	^ (SBWatchValue newContainerMorphFor: aSBWatchValue)  
		addMorphBack: (aSBMorphResizer applyOn: self sbSnapshot asMorph);
		yourself
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> topLevelVariants [

	^ Array streamContents: [:stream | self topLevelVariantsDo: [:block | stream nextPut: block]]
]

{ #category : #'*Sandblocks-Babylonian' }
Morph >> topLevelVariantsDo: aBlock [

	self submorphsDo: [:morph |
		(morph isSandblock and: [morph isVariant])
			ifTrue: [aBlock value: morph]
			ifFalse: [morph topLevelVariantsDo: aBlock]]
]
