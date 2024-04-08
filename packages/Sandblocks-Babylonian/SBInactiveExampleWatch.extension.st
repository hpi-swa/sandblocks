Extension { #name : #SBInactiveExampleWatch }

{ #category : #'*Sandblocks-Babylonian' }
SBInactiveExampleWatch >> listensToExamples [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBInactiveExampleWatch >> saveObjectsActivePermutations [

	"Force morphs to persist their permutation even when on the UI process"
	"exampleToValues associationsDo: [:anExampleValuesPair | 
		anExampleValuesPair value do: [:aWatchValue |
			aWatchValue watchedValue allMorphsDo: [:aSubMorph | 
				SBExploriants objectToPermutation 
					at: aSubMorph 
					put: SBActiveVariantPermutation value]]]."
	exampleToDisplay associationsDo: [:anExampleDisplayPair |
		anExampleDisplayPair value displayedWatchValueBlocks do: [:aValueMorph | 
			aValueMorph lastSubmorph allMorphsDo: [:aSubMorph | 
				SBExploriants objectToPermutation 
					at: aSubMorph 
					put: self createdWithPermutation]]].
]
