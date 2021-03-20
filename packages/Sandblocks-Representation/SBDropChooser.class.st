Class {
	#name : #SBDropChooser,
	#superclass : #SBBlock,
	#instVars : [
		'original',
		'interface',
		'applyBlock',
		'currentBlock'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBDropChooser >> artefactChanged: anArtefact [

	self delete
]

{ #category : #'as yet unclassified' }
SBDropChooser >> click: anEvent [

	| options index |
	self sandblockEditor undo.
	options := Array streamContents: [:stream | original allConversionsFor: interface do: [:pair | stream nextPut: pair]].
	index := UIManager default chooseFrom: (options collect: #first).
	index > 0 ifTrue: [applyBlock value: (options at: index) second].
	self delete
]

{ #category : #'as yet unclassified' }
SBDropChooser >> drawBackgroundOn: aCanvas [

	aCanvas
		frameAndFillRoundRect: self bounds
		radius: 15
		fillStyle: self drawnColor
		borderWidth: (self colorPolicy borderWidthForBlock: self)
		borderColor: (self colorPolicy borderColorForBlock: self)
]

{ #category : #'as yet unclassified' }
SBDropChooser >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBDropChooser >> initialize [

	super initialize.
	
	self
		layoutPolicy: SBHorizontalLayout new;
		cellGap: 8;
		layoutInset: 8 @ 4;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: SBIcon iconRetweet;
		addMorphBack: (SBColumn new
			addMorphBack: (SBStringMorph new
				contents: 'Auto Converted';
				bold);
			addMorphBack: (SBStringMorph new contents: 'See all options'))
]

{ #category : #'as yet unclassified' }
SBDropChooser >> intoWorld: aWorld [

	self sandblockEditor when: #selectionChanged send: #delete to: self
]

{ #category : #'as yet unclassified' }
SBDropChooser >> openFor: aBlock interface: aCollection original: anObject do: aBlockClosure [

	interface := aCollection.
	applyBlock := aBlockClosure.
	currentBlock := aBlock.
	original := anObject.
	
	self position: aBlock topRight.
	
	aBlock sandblockEditor openMorph: self
]

{ #category : #'as yet unclassified' }
SBDropChooser >> outOfWorld: aWorld [

	self sandblockEditor removeActionsWithReceiver: self
]

{ #category : #'as yet unclassified' }
SBDropChooser >> preventOcclusion [

	^ false
]

{ #category : #'as yet unclassified' }
SBDropChooser >> step [

	currentBlock sandblockEditor ifNil: [self delete]
]
