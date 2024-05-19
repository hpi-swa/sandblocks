Class {
	#name : #SBCorrelationView,
	#superclass : #SBResizableResultsView,
	#instVars : [
		'variantSelection',
		'selectedVariants',
		'basePermutations',
		'groupedUniverses'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBCorrelationView >> buildAllPossibleResults [
	
	groupedUniverses := self groupUniversesContainingAllVariantsIn: selectedVariants.
	basePermutations := self collectAllPermutationsOfSelectedVariants asOrderedCollection.

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
						'{1} {2}' format: {anExample label.
											 (aWatch cleanedExpression sourceString withoutLineEndings)}).
					self containerRow 
						listDirection: #topToBottom;
						cellPositioning:  #rightCenter;
						cellInset: 0@10;
						addAllMorphsBack: ((self buildGridsFor: anExample watching: aWatch) flatten)}})
]

{ #category : #building }
SBCorrelationView >> buildGridsFor: anExample watching: aWatch [
	
	^ (basePermutations collect: [:aBasePermutation |
		SBCorrelationCluster 
			newForSize: self selectedResizer 
			example: anExample 
			watch: aWatch 
			basePermutation: aBasePermutation
			correlating: (self getUniversesContainingPermutation: aBasePermutation)]),
		 (groupedUniverses second collect: [:aNonCorrelatingUniverse | 
				SBCorrelationCluster 
					newForSize: self selectedResizer 
					example: anExample 
					watch: aWatch 
					basePermutation: aNonCorrelatingUniverse activePermutation 
					correlating: {aNonCorrelatingUniverse}]) 
]

{ #category : #building }
SBCorrelationView >> buildSelectionOptions [

	| container selectedString |
	container := Morph new
					color: Color transparent;
					changeTableLayout;
					vResizing: #shrinkWrap;
					hResizing: #shrinkWrap;
					listDirection: #leftToRight.
	self ensureVariantSelectionIn: container.
	selectedString := ''.
	selectedVariants 
		ifEmpty: [ selectedString := selectedString, 'None' ]
		ifNotEmpty: [ selectedString := selectedString, ((selectedVariants collect: #name) fold: [:a :b | a, ', ', Character cr, b ])]. 
	container addMorphBack: selectedString withoutLineEndings asMorph.
	^ container
	
]

{ #category : #building }
SBCorrelationView >> buildVariantSelection [

	| options topLevelVariant |
	options := self multiverse variants.
	topLevelVariant := options detect: [:aVariant | aVariant parentVariant isNil] ifNone: [options first].

	^ SBComboBox new
		prefix: 'Configure Y Axis';
		labels: (options collect: #name);
		values: options;
		object: topLevelVariant;
		when: #selectionChanged send: #changeVariants to: self;
		displayPrefixOnly 
]

{ #category : #accessing }
SBCorrelationView >> buttons [
		
	^ super buttons, {self buildSelectionOptions}
]

{ #category : #building }
SBCorrelationView >> changeVariants [

	(selectedVariants includes: variantSelection object)
		ifTrue: [selectedVariants remove: variantSelection object] 
		ifFalse: [selectedVariants add: variantSelection object].
		
	self visualize
]

{ #category : #building }
SBCorrelationView >> collectAllPermutationsOfSelectedVariants [
	
	| allPermutations |
	selectedVariants ifEmpty: [^ {SBPermutation singularity} asSet].
	allPermutations := Set new.
	groupedUniverses first do: [:aUniverseContainingSelected | | base |
		base := SBPermutation new referencedVariants: selectedVariants.
		selectedVariants do: [:aVariant | base at: aVariant id put: (aUniverseContainingSelected activePermutation at: aVariant id)].
		allPermutations add: base].
	^ allPermutations
]

{ #category : #building }
SBCorrelationView >> ensureVariantSelectionIn: aMorph [

	self multiverse variants ifEmpty: [selectedVariants := OrderedCollection new. ^ self].
	variantSelection := self buildVariantSelection.
	aMorph addMorph: variantSelection.
	
	selectedVariants 
		ifNil: [selectedVariants := {variantSelection object} asOrderedCollection]
		ifNotNil: [selectedVariants := selectedVariants select: [:aVariant | self multiverse variants includes: aVariant]].
	
]

{ #category : #building }
SBCorrelationView >> getUniversesContainingPermutation: aPermutation [
		
	^ groupedUniverses first select: [:aUniverse | 
		aUniverse activePermutation contains: aPermutation]
]

{ #category : #building }
SBCorrelationView >> groupUniversesContainingAllVariantsIn: aCollectionOfVariants [
	
	| contains omits |
	contains := OrderedCollection new.
	omits := OrderedCollection new.
	self multiverse universes do: [:aUniverse | 
		(aCollectionOfVariants allSatisfy: [:aVariant | aUniverse activePermutation referencedVariants includes: aVariant])
			ifTrue: [contains add: aUniverse] 
			ifFalse: [omits add: aUniverse]].
	
	^ {contains. omits.}
]

{ #category : #building }
SBCorrelationView >> groupUniversesContainingPermutation: aPermutation [
		
	| contains omits |
	contains := OrderedCollection new.
	omits := OrderedCollection new.
	groupedUniverses first do: [:aUniverse | 
		(aUniverse activePermutation contains: aPermutation)
			ifTrue: [contains add: aUniverse] 
			ifFalse: [omits add: aUniverse]].
	
	^ {contains. omits.}
]

{ #category : #initialization }
SBCorrelationView >> initialize [ 

	super initialize.
	
	self name: 'Correlation'.
	
]

{ #category : #accessing }
SBCorrelationView >> wantsReloadOnSaveWhenOpen [

	^ true
]
