"
A helper class with synctactic sugars for variant id -> alternative index dictionary
"
Class {
	#name : #SBPermutation,
	#superclass : #Dictionary,
	#type : #variable,
	#instVars : [
		'referencedVariants'
	],
	#category : #'Sandblocks-Utils'
}

{ #category : #utils }
SBPermutation class >> allPermutationsOf: aCollectionOfVariants [

	| permutations topLevelVariants nestedPermutations |
	aCollectionOfVariants ifEmpty:[^{SBNilPermutation new referencedVariants: {}}].
	topLevelVariants := aCollectionOfVariants select: [:aVariant | aVariant parentVariant isNil].
	nestedPermutations := topLevelVariants collect: #allPermutations.
	permutations := nestedPermutations first.
	
	(2 to: topLevelVariants size) do: [:i | | nestedPermutation |
		nestedPermutation := (nestedPermutations at: i).
		permutations := permutations gather: [:aPermutation | 
			nestedPermutation collect: [:aNestedPermutation | self newCombinedOf: aPermutation and: aNestedPermutation]]].
	
	^ permutations 
		
]

{ #category : #utils }
SBPermutation class >> newCombinedOf: onePermutation and: anotherPermutation [

	| result |
	result := self new referencedVariants: 
		((onePermutation referencedVariants, anotherPermutation referencedVariants) asSet 
			sorted: [:a :b | a name <= b name]).
	result addAll: onePermutation.
	result addAll: anotherPermutation.
	^ result
	
]

{ #category : #accessing }
SBPermutation >> activeScore [

	^ (self referencedVariants collect: [:aVariant |
		aVariant activeIndex = (self at: aVariant id) ifTrue: [1] ifFalse: [0]]) 
		inject: 0 into: [:a :c | a + c]
]

{ #category : #actions }
SBPermutation >> apply [

	self referencedVariants do: [:aVariant | aVariant switchToAlternative: (self at: aVariant id)].
	((Set newFrom: (referencedVariants collect: #sandblockEditor))
		reject: #isNil)
		do: #sendNewPermutationNotification
]

{ #category : #converting }
SBPermutation >> asString [
	
	"collecting instead of calling (a active name), ', ', (b active name) in fold
	as one variant only will not return a string but a variant"
	^ (self referencedVariants collect: [:aVariant | 
			aVariant name, ': ', (aVariant blockAt: (self at: aVariant id)) nameToDisplay ]) 
			fold: [:a :b | a, ', ', Character cr, b ]

	
]

{ #category : #converting }
SBPermutation >> asStylizedText [

	| text |
	text := Text fromString: self asString.
	^ self isActive
		ifTrue: [text allBold] 
		ifFalse: [text]

	
]

{ #category : #accessing }
SBPermutation >> isActive [

	^ self activeScore = self referencedVariants size
]

{ #category : #accessing }
SBPermutation >> referencedVariants [

	^ referencedVariants
]

{ #category : #accessing }
SBPermutation >> referencedVariants: anObject [

	referencedVariants := anObject
]
