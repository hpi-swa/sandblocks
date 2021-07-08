Class {
	#name : #SBSlideBlock,
	#superclass : #SBBlock,
	#instVars : [
		'slideNumber'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSlideBlock >> initialize [ 
	
	super initialize.
	self
		changeTableLayout;
		hResizing: #rigid;
		vResizing: #rigid;
		layoutInset: 8;
		attachDecorator: SBResizableDecorator new;
		attachDecorator: SBForceMoveDecorator newConfigured;
		extent: 200 asPoint 
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> isArtefact [ 
	
	^ true
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> isInteractive [ 
	
	^ false
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> pickSlide [
	<action>
	slideNumber := (UIManager default request: 'Slide Number' initialAnswer: '1') asNumber.
	self addMorphBack: (PSPresentation mainSlideAt: slideNumber) veryDeepCopy 
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> updateSelection: anObject [
	
]
