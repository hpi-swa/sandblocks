Class {
	#name : #SBVariantsView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBVariantsView >> buildMethodSectionFor: aSBStMethod [
	
	self block addAllMorphsBack: {aSBStMethod methodDefinition.
									self containerRow 
										addAllMorphsBack: (aSBStMethod containedVariants collect: #asProxy).
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #building }
SBVariantsView >> buildNoVariantsText [
	
	self block addMorphBack: (SBOwnTextMorph new contents: 'No variants exist.')
]

{ #category : #initialization }
SBVariantsView >> initialize [ 

	super initialize.
	
	self name: 'Variant Manager'.
]

{ #category : #actions }
SBVariantsView >> visualize [ 

	self clean.

	self allMethodBlocksContainingVariants 
		ifNotEmptyDo: [:theMethods | theMethods do: [:aSBStMethod | self buildMethodSectionFor: aSBStMethod]] 
		ifEmpty: [self buildNoVariantsText]
]
