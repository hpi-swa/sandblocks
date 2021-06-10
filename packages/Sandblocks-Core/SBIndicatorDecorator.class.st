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

	
	aMorph sandblockEditor isSelection ifFalse: [	
		self indicator: (SBOffscreenBlockIndicator newFor: aMorph).
		aMorph sandblockEditor openMorphInOverlay: self indicator].
	
	aMorph addDependent: self.

]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> detached: aMorph [

	self indicator ifNotNil: [self indicator abandon]
]

{ #category : #accessing }
SBIndicatorDecorator >> indicator [

	^ indicator
]

{ #category : #accessing }
SBIndicatorDecorator >> indicator: aMorph [

	indicator := aMorph.
]

{ #category : #accessing }
SBIndicatorDecorator >> morph [

	^ morph
]

{ #category : #accessing }
SBIndicatorDecorator >> morph: aBlock [

	morph := aBlock.
]

{ #category : #'as yet unclassified' }
SBIndicatorDecorator >> update: aParameter [

	self morph withDecorator: SBForceMoveDecorator do: [:decorator |
		 self indicator shouldHide: decorator group notNil]
]
