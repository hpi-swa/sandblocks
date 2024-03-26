Class {
	#name : #SBCorrelationView,
	#superclass : #SBResizableResultsView,
	#instVars : [
		'basePermutations'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #accessing }
SBCorrelationView >> basePermutations [
	^ basePermutations
]

{ #category : #accessing }
SBCorrelationView >> basePermutations: anObject [
	basePermutations := anObject
]

{ #category : #building }
SBCorrelationView >> buildAllPossibleResults [
	
	| base thisVariant |
	self multiverse activeExamples 
		ifEmpty: [gridContainer addMorph: (TextMorph new contents: 'No examples active').
				  gridContainer width: gridContainer firstSubmorph width + 5 "a bit of margin"].
	
	thisVariant := self multiverse universes first activePermutation referencedVariants third.
	base := SBPermutation new referencedVariants: (self multiverse universes first activePermutation referencedVariants select: [:var | var = thisVariant]).
	self multiverse universes first activePermutation associationsDo: [:idToNum | idToNum key = thisVariant id ifTrue: [base add: idToNum]].
	self halt.
	self basePermutations: {base}.

	self multiverse activeExamples do: [:anExample |
		self multiverse watches do: [:aWatch | 
			self buildForExample: anExample watching: aWatch]]
]

{ #category : #building }
SBCorrelationView >> buildForExample: anExample watching: aWatch [

	gridContainer addMorphBack: (self containerRow cellPositioning: #center;
		addAllMorphsBack: {
			self containerRow listDirection: #topToBottom;
				addAllMorphsBack: { 
					SBOwnTextMorph new contents: (
						'{1}, {2}' format: {anExample label.
											 (aWatch cleanedExpression sourceString)}).
					self buildGridsFor: anExample watching: aWatch} flatten})
]

{ #category : #building }
SBCorrelationView >> buildGridsFor: anExample watching: aWatch [

	^ (self basePermutations collect: [:aBasePermutation | | split |
		split := self getAllUniversesContainingPermutation: aBasePermutation.
		{SBCorrelationCluster 
			newForSize: self selectedResizer 
			multiverse: self multiverse 
			example: anExample 
			watch: aWatch 
			basePermutation: aBasePermutation 
			opponentPermutations: split first },
		(split second collect: [:nonContainingPermutation | 
			SBCorrelationCluster 
				newForSize: self selectedResizer 
				multiverse: self multiverse 
				example: anExample 
				watch: aWatch 
				basePermutation: nonContainingPermutation 
				opponentPermutations: {SBNilPermutation new referencedVariants: {}}])	
		]) flatten
	
]

{ #category : #building }
SBCorrelationView >> getAllUniversesContainingPermutation: aPermutation [

	| containsBase rest |
	containsBase := OrderedCollection new.
	rest := OrderedCollection new.
	
	 self multiverse universes do: [:aUniverse | 
		((aUniverse activePermutation contains: aPermutation))
			ifTrue: [containsBase add: (aUniverse activePermutation copyRemoving: {aPermutation}) ]
			ifFalse: [rest add: aUniverse activePermutation]].
	
	^ {containsBase reject: [:aContainingPermutation | aContainingPermutation = aPermutation].
		rest ifEmpty: [{SBNilPermutation new referencedVariants: {}}]}
]

{ #category : #initialization }
SBCorrelationView >> initialize [ 

	super initialize.
	
	self name: 'Correlation'.
	
]
