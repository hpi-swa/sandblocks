"
helper class w/ synctactic sugars for variant -> alternative index dictionary
"
Class {
	#name : #SBPermutation,
	#superclass : #Dictionary,
	#type : #variable,
	#instVars : [
		'referencedVariants'
	],
	#category : #'Sandblocks-Smalltalk'
}

{ #category : #utils }
SBPermutation class >> allPermutationsOf: aCollectionOfVariants [

	"Returns a Collection of Collections containing indexes of alternatives,
	e.g. a collection of two Variants, with A having 2 alternatives and B having 3, would result in
	#( (A->1 B->1) (A->1 B->2) (A->1 B->3) 
	     (A->2 B->1) (A->2 B->2) (A->2 B->3))"
	| permutations |
	permutations := (1 to: aCollectionOfVariants first alternativesCount) 
		collect: [:anIndex | {anIndex}].
	
	(2 to: aCollectionOfVariants size) do: [:i | | alternatives |
		alternatives := (aCollectionOfVariants at: i) alternativesCount.
		permutations := permutations gather: [:aCollectionOfIndexes | 
			(1 to: alternatives) collect: [:aTabIndex | 
				{aCollectionOfIndexes. aTabIndex} flatten]]].
	
	^ permutations collect: [:aCollectionOfIndexes | 
		(self withAll: (aCollectionOfIndexes withIndexCollect: [:anAlternativeIndex :aVariantIndex | 
			(aCollectionOfVariants at: aVariantIndex) id -> anAlternativeIndex]))
		referencedVariants: aCollectionOfVariants]
		
]

{ #category : #accessing }
SBPermutation >> referencedVariants [
	^ referencedVariants
]

{ #category : #accessing }
SBPermutation >> referencedVariants: anObject [
	referencedVariants := anObject
]
