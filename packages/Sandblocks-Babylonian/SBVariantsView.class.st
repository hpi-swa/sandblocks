Class {
	#name : #SBVariantsView,
	#superclass : #SBExploriantsView,
	#instVars : [
		'contents'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #building }
SBVariantsView >> buildMethodSectionFor: aSBStMethod [
	
	| newProxy |
	newProxy := aSBStMethod containedVariants collect: #asProxy.
	contents addAllMorphsBack: {aSBStMethod methodDefinition.
									self containerRow addAllMorphsBack: newProxy.
									LineMorph from: 0@0 to: 50@0 color: Color black width: 2}
]

{ #category : #building }
SBVariantsView >> buildNoVariantsText [
	
	contents addMorphBack: (SBOwnTextMorph new contents: 'No variation points exist.')
]

{ #category : #actions }
SBVariantsView >> changeIndexOf: aVariantId to: aNewIndex [

	self proxies
		detect: [:aProxy | aProxy original id = aVariantId] 
		ifFound: [:theProxy | theProxy changeActiveIndexTo: aNewIndex ]
]

{ #category : #actions }
SBVariantsView >> clean [

	super clean.
	
	contents submorphs copy do: #delete.
	
]

{ #category : #initialization }
SBVariantsView >> initialize [ 

	super initialize.
	
	contents := self containerRow listDirection: #topToBottom.
	
	self name: 'Variation Points'.
]

{ #category : #accessing }
SBVariantsView >> isVariantsView [

	^ true
]

{ #category : #actions }
SBVariantsView >> proxies [

	^ (contents allMorphs select: [:aMorph | aMorph isKindOf: SBVariantProxy])
]

{ #category : #copying }
SBVariantsView >> snapshot [

	^ ImageMorph new newForm: contents imageForm
]

{ #category : #actions }
SBVariantsView >> visualize [ 

	super visualize.
	self block addMorphBack: contents.
	self multiverse allMethodBlocksContainingVariants
		ifNotEmptyDo: [:theMethods | theMethods do: [:aSBStMethod | self buildMethodSectionFor: aSBStMethod]] 
		ifEmpty: [self buildNoVariantsText]
]

{ #category : #copying }
SBVariantsView >> wantsHistory [ 

	^ false
]
