Class {
	#name : #SBVariantsView,
	#superclass : #SBExploriantsView,
	#category : #'Sandblocks-Core'
}

{ #category : #building }
SBVariantsView >> buildMethodSectionFor: aSBStMethod [
	
	self block addMorphBack: aSBStMethod methodHeader copy.
	self block addMorphBack: (self containerRow 
		addAllMorphsBack: (aSBStMethod containedVariants collect: #asProxy)).
	self block addMorphBack: (LineMorph from: 0@0 to: 50@0 color: Color black width: 2).
]

{ #category : #initialization }
SBVariantsView >> initialize [ 

	super initialize.
	
	self name: 'Variant Manager'.
	
	self visualize
]

{ #category : #actions }
SBVariantsView >> visualize [ 

	self allMethodBlocksContainingVariants do: [:aSBStMethod | self buildMethodSectionFor: aSBStMethod]
]
