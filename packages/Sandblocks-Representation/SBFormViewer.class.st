Class {
	#name : #SBFormViewer,
	#superclass : #SBBlock,
	#instVars : [
		'addMorphLater'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBFormViewer >> asMorphBlock: convert [
	<convert>
	
	" we ignore requests to wrap ourselves "
]

{ #category : #'as yet unclassified' }
SBFormViewer >> initialize [

	super initialize.
	self
		attachDecorator: SBMoveDecorator new;
		extent: 100 asPoint;
		attachDecorator: SBResizableDecorator new;
		changeTableLayout;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		layoutInset: 6 withScalingFactor
]

{ #category : #'as yet unclassified' }
SBFormViewer >> isTopLevel [

	^ true
]

{ #category : #'as yet unclassified' }
SBFormViewer >> isViewer [

	^ true
]

{ #category : #'as yet unclassified' }
SBFormViewer >> object [

	^ self firstSubmorph form
]

{ #category : #'as yet unclassified' }
SBFormViewer >> replace: aForm [

	self removeAllMorphs.
	self addMorphBack: aForm asMorph
]
