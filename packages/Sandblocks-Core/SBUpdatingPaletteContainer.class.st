Class {
	#name : #SBUpdatingPaletteContainer,
	#superclass : #SBPaletteContainer,
	#instVars : [
		'currentPalettes',
		'selectedBlock',
		'palettes'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> addNoPalettesNotice [

	categories addMorphBack: (SBStringMorph new contents: 'No Palettes').
	content removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> build [

	content removeAllMorphs.
	categories removeAllMorphs.
	^ currentPalettes do: [:palette | | p |
		p := palettes at: palette.
		content addMorphBack: p.
		categories addMorphBack: p categories]
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> delete [

	super delete.
	categories removeAllMorphs.
	content removeAllMorphs.
	currentPalettes := {}.
	palettes reset
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> initialize [

	super initialize.
	
	currentPalettes := {}.
	palettes := LRUCache size: 10 factory: [:key | | container |
		container := SBPaletteBuilder new.
		key buildOn: container.
		container].
	
	self
		minimumWidth: 270;
		shadowOffset: (-10 @ 0 corner: 10 @ 0);
		hasDropShadow: true;
		shadowColor: ((Color r: 0.0 g: 0.0 b: 0.0) alpha: 0.01);
		layoutInset: (SBEdgeInsets right: 4);
		detachDecorators: SBResizableDecorator;
		attachDecorator: (SBResizableDecorator new edge: #right)
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> rebuild [

	palettes reset.
	self build
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> removeNoPalettesNotice [

	"self assert: categories submorphCount <= 1."
	categories removeAllMorphs
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> selectedBlock [

	^ selectedBlock
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> selection [

	^ self sandblockEditor selection
]

{ #category : #'as yet unclassified' }
SBUpdatingPaletteContainer >> selectionChanged: aBlock [

	| newPalettes |
	((aBlock isNil or: [aBlock isInEditor not]) or: [(aBlock hasOwner: self) or: [aBlock = self]]) ifTrue: [^ self].
	
	selectedBlock := aBlock.
	currentPalettes ifEmpty: [self removeNoPalettesNotice].
	
	newPalettes := ((Array streamContents: [:stream | aBlock andAllParentSandblocksDo: [:p | stream nextPutAll: p palettes]]), (SBPalette allSubclasses select: [:palette | (aBlock satisfies: palette context) and: [palette matchesBlock: aBlock]])) withoutDuplicates.
	
	(newPalettes hasEqualElements: currentPalettes) ifFalse: [
		currentPalettes := newPalettes.
		self build].
	
	currentPalettes ifEmpty: [self addNoPalettesNotice].
	
	search contents: ''.
	self layoutChanged
]
