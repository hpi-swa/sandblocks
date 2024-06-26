"
Does not update its results anymore. Applying modification expressions is still possible.
"
Class {
	#name : #SBInactiveExampleWatch,
	#superclass : #SBExampleWatch,
	#instVars : [
		'originalIdentifier',
		'createdWithPermutation'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #'event handling' }
SBInactiveExampleWatch class >> registerWatch: aWatch [

	"we do not want the inactive watches in the registry"
]

{ #category : #'event handling' }
SBInactiveExampleWatch class >> unregisterWatch: aWatch [

	"we do not want the inactive watches in the registry"
]

{ #category : #callbacks }
SBInactiveExampleWatch >> artefactSaved: aBlock [

	"As we are inactive, we have to manually apply our modifyExpression if it changes. 
	Otherwise, we would reset by examples starting" 
	(aBlock = self containingArtefact) 
		ifTrue: [self applyModifyExpressionOnValues. self saveObjectsActivePermutations.]
]

{ #category : #accessing }
SBInactiveExampleWatch >> createdWithPermutation [

	^ createdWithPermutation
]

{ #category : #accessing }
SBInactiveExampleWatch >> createdWithPermutation: aPermutation [

	createdWithPermutation := aPermutation
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

{ #category : #accessing }
SBInactiveExampleWatch >> originalIdentifier [

	^ originalIdentifier
]

{ #category : #accessing }
SBInactiveExampleWatch >> originalIdentifier: aNumber [

	originalIdentifier := aNumber
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
