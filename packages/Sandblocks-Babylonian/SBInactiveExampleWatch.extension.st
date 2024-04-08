Extension { #name : #SBInactiveExampleWatch }

{ #category : #'*Sandblocks-Babylonian' }
SBInactiveExampleWatch >> listensToExamples [

	^ false
]

{ #category : #'*Sandblocks-Babylonian' }
SBInactiveExampleWatch >> saveObjectsActivePermutations [

	"Force morphs to persist their permutation even when on the UI process"
	exampleToDisplay associationsDo: [:anExampleDisplayPair |
		anExampleDisplayPair value displayedWatchValueBlocks do: [:aValueMorph | 
			aValueMorph lastSubmorph allMorphsDo: [:aSubMorph | 
				SBExploriants objectToPermutation 
					at: aSubMorph 
					put: self createdWithPermutation]]].
]
