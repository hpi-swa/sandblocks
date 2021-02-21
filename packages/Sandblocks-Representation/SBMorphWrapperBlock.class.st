Class {
	#name : #SBMorphWrapperBlock,
	#superclass : #SBBlock,
	#instVars : [
		'addMorphLater'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> addMorphLater: aMorph [

	addMorphLater := aMorph
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> asMorphBlock: convert [
	<convert>
	
	" we ignore requests to wrap ourselves "
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> childSandblocksDo: aBlock [
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> initialize [

	super initialize.
	self
		attachDecorator: SBMoveDecorator new;
		extent: 100 asPoint;
		attachDecorator: SBResizableDecorator new;
		changeTableLayout;
		layoutInset: 6 withScalingFactor
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> intoWorld: aWorld [

	super intoWorld: aWorld.

	" since our newFrom: needs to be side-effect free, we queue up adding the morph until we're actually being used "	
	addMorphLater ifNotNil: [
		self addMorphBack: addMorphLater.
		self extent: (addMorphLater extent + self layoutInset asEdgeInsets asPoint).
		addMorphLater := nil]
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> isViewer [

	^ true
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> object [

	^ self firstSubmorph
]

{ #category : #'as yet unclassified' }
SBMorphWrapperBlock >> replace: anObject [

	self removeAllMorphs.
	self addMorphBack: anObject
]
