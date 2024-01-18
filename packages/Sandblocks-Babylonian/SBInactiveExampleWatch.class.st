"
Does not update its results anymore. Applying modification expressions is still possible.
"
Class {
	#name : #SBInactiveExampleWatch,
	#superclass : #SBExampleWatch,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'initialize-release' }
SBInactiveExampleWatch class >> newFromWatch: anActiveWatch [

	^ (anActiveWatch veryDeepCopy)
		primitiveChangeClassTo: self basicNew;
		expression: (SBTextBubble new contents: anActiveWatch cleanedExpression sourceString);
		saveObjectsActivePermutations;
		yourself 
]

{ #category : #'event handling' }
SBInactiveExampleWatch class >> registerWatch: aWatch [

	"we do not want the inactive watches in the registry"
]

{ #category : #callbacks }
SBInactiveExampleWatch >> artefactSaved: aBlock [

	"As we are inactive, we have to manually apply our modifyExpression if it changes. 
	Otherwise, we would reset by examples starting" 
	(aBlock = self containingArtefact) 
		ifTrue: [self applyModifyExpressionOnValues. self saveObjectsActivePermutations.]
]

{ #category : #'event handling' }
SBInactiveExampleWatch >> doubleClick: evt [
	
	"Nothing"
]

{ #category : #accessing }
SBInactiveExampleWatch >> expression: aBlock [

	super expression: aBlock.
	watchedExpression selectable: false
]

{ #category : #accessing }
SBInactiveExampleWatch >> isActive [

	^ false
]

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
					put: SBActiveVariantPermutation value]]].
]
