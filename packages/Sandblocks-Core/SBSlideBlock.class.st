Class {
	#name : #SBSlideBlock,
	#superclass : #SBBlock,
	#instVars : [
		'slideNumber'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBSlideBlock class >> newForSlideNumber: aNumber [

	^ self new setSlide: aNumber
]

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

	self setSlide: (UIManager default request: 'Slide Number' initialAnswer: '1') asNumber
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> removeSelection [
	"do nothing"

	
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> saveString [

	^ String streamContents: [:stream |
		self printSaveStringPreambleOn: stream.
		stream
			nextPutAll: '(';
			nextPutAll: self className;
			nextPutAll: ' newForSlideNumber: ';
			nextPutAll: slideNumber asString;
			nextPutAll: ') position: ';
			nextPutAll: self position asString;
			nextPutAll: '; extent: ';
			nextPutAll: self extent asString]
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> setSlide: aNumber [

	slideNumber := aNumber.
	self addMorphBack: (PSPresentation mainSlideAt: slideNumber) veryDeepCopy
]

{ #category : #'as yet unclassified' }
SBSlideBlock >> updateSelection: anObject [
	
]
