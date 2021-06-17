Class {
	#name : #SBIndicatorDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'indicator'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> attached: aMorph [

	super attached: aMorph.
	self indicator: (SBOffscreenBlockIndicator newFor: aMorph).
	aMorph sandblockEditor ifNotNil: [:editor | editor openMorphInOverlay: self indicator]
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> block: aBlock [
	"ignore this for performAction in block"

	
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
SBIndicatorDecorator >> toggleHighlight [
	<action>

	self indicator toggleHighlight.
	
	
	
]
