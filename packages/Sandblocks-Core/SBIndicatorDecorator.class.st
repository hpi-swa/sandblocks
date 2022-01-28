Class {
	#name : #SBIndicatorDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'indicator'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> block: aBlock [
	"ignore this for performAction in block"

	
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> detached: aMorph [

	self indicator ifNotNil: #abandon.
	super detached: aMorph
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> indicator [

	^ indicator
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> indicator: anSBOffscreenBlockIndicator [

	indicator := anSBOffscreenBlockIndicator
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> noteNewOwner: aMorph [

	self indicator ifNotNil: [:indicator | indicator abandon].
	aMorph parentSandblock ifNil: [^ self].
	(aMorph parentSandblock = self morph sandblockEditor and: [aMorph parentSandblock isSingleArtefactView not]) ifTrue: [
		self indicator: (SBOffscreenBlockIndicator newFor: self morph).
		self morph sandblockEditor ifNotNil: [:editor | editor openMorphInOverlay: self indicator]]
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> postDrawOn: aCanvas [

	| color b |
	self indicator ifNotNil: [:indicator | indicator isHighlighted ifTrue: [
		color := self indicator iconMorph color.
		b := self morph bounds expandBy: 5.
		self morph invalidRect: (self morph outerBounds expandBy: 5).
		aCanvas frameRoundRect: b radius: self morph colorPolicy cornerRadius width: 5 color: color]]
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> toggleHighlight [
	<action>

	self indicator toggleHighlight.
	
	
	
]
