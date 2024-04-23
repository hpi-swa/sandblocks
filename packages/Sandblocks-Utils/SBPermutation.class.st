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
	
	self flag: #todo. "outdated references, jb" 
	(self referencedVariants anySatisfy: [:aVariant | aVariant sandblockEditor isNil])
		ifTrue: [ self applyWithOutdatedReferences ]
		ifFalse: [ self applyOnOriginals ].
	
	
]

{ #category : #private }
SBPermutation >> applyOnOriginals [
	
	self referencedVariants do: [:aVariant | aVariant switchToAlternativeWithoutSaving: (self at: aVariant id)].
	SBExploriants uniqueInstance ignoreUpdate: true.
	((self referencedVariants collect: #containingArtefact) asSet) do: [:aMethod | 
		aMethod sandblockEditor save: aMethod tryFixing: false quick: false].
	(self referencedVariants collect: #sandblockEditor) do: #sendNewPermutationNotification
	
	
]

{ #category : #private }
SBPermutation >> applyWithOutdatedReferences [
	
	| newVariants |
	self keys do: [:anId | SBExploriants uniqueInstance changeIndexOf: anId to: (self at: anId)].
	newVariants := SBExploriants uniqueInstance variantsView proxies collect: #original.
	self referencedVariants do: [:aVariant | 
		newVariants detect: [:new | new id = aVariant id] 
			ifFound: [:theVariant | aVariant becomeForward: theVariant]].
	SBEditor current sendNewPermutationNotification
	
	
]

{ #category : #converting }
SBPermutation >> asString [
	
	"collecting instead of calling (a active name), ', ', (b active name) in fold
	as one variant only will not return a string but a variant"
	^ (self referencedVariants collect: [:aVariant | 
			((aVariant name endsWith: ':') ifTrue: [aVariant name, ' '] ifFalse: [aVariant name, ': ']), 
			(aVariant blockAt: (self at: aVariant id)) nameToDisplay ]) 
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

{ #category : #converting }
SBPermutation >> asVariantString [
	
	^ (self referencedVariants collect: [:aVariant | aVariant name]) fold: [:a :b | a, ', ', Character cr, b ]

	
]

{ #category : #accessing }
SBPermutation >> contains: anotherPermutation [

	anotherPermutation associationsDo: [:idToNum |
		(self includesKey: idToNum key) ifFalse: [^false].
		(self at: idToNum key) ~= idToNum value ifTrue: [^false]].
	
	^ true
]

{ #category : #'initialize-release' }
SBPermutation >> copyRemovingPermutation: aPermutation [

	 | copy |
	copy := self veryDeepCopy.
	copy referencedVariants: (copy referencedVariants reject: [:aVariant | 
		aPermutation includesKey: aVariant id]).
		
	aPermutation associationsDo: [:idToNum | 
		copy at: idToNum key ifPresent: [:theValue | theValue = idToNum value 
					ifTrue: [copy removeKey: idToNum key]]].
	^ copy
		
]

{ #category : #'initialize-release' }
SBPermutation >> copyRemovingVariants: aCollectionOfVariants [

	 | copy |
	copy := self class new.
	copy referencedVariants: (self referencedVariants reject: [:aVariant | aCollectionOfVariants includes: aVariant]).
	copy referencedVariants ifEmpty: [^ SBNilPermutation new referencedVariants: {}]. 
	"copy := self veryDeepCopy.
	copy referencedVariants: (copy referencedVariants difference: aCollectionOfVariants)."
	
	self associationsDo: [:anAssc | copy add: anAssc].
	aCollectionOfVariants do: [:aVariant | copy removeKey: aVariant id ifAbsent: []].
	^ copy
		
]

{ #category : #'initialize-release' }
SBPermutation >> initialize [ 

	super initialize.
	
	self referencedVariants: OrderedCollection new.
]

{ #category : #accessing }
SBPermutation >> isActive [

	^ self activeScore = self referencedVariants size
]

{ #category : #accessing }
SBPermutation >> isNilPermutation [

	^ false
]

{ #category : #accessing }
SBPermutation >> referencedVariants [

	^ referencedVariants
]

{ #category : #accessing }
SBPermutation >> referencedVariants: anObject [

	referencedVariants := anObject
]
