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
			SBExploriants objectToPermutation 
				at: aValueMorph lastSubmorph 
				put: SBActiveVariantPermutation value]].
]
