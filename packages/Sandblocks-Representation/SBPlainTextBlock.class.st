Class {
	#name : #SBPlainTextBlock,
	#superclass : #SBBlock,
	#instVars : [
		'text'
	],
	#category : #'Sandblocks-Representation'
}

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> contents [

	^ text contents
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> contents: aString [

	text contents: aString
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> currentTextMorph [

	^ text
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> drawnColor [

	^ Color white
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> example [

	SBMorphExample
		setUp: [SBPlainTextBlock new]
		cases: {SBMorphExampleCase name: 'example 1' caseBlock: [:m | m]}
		extent: 300 @ 300
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> initialize [

	super initialize.
	self
		layoutPolicy: TableLayout new;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		layoutInset: 8;
		addMorphBack: (text := SBMultilineOwnTextMorph new);
		attachDecorator: SBMoveDecorator new
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> keyStroke: anEvent [

	text keyStroke: anEvent
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> object [

	^ self contents
]

{ #category : #'as yet unclassified' }
SBPlainTextBlock >> startInputAt: aNumber replacingContents: aBoolean [

	| cmd |
	cmd := SBInputCommand new
		oldMorph: self;
		previousText: self contents;
		yourself.
	
	aBoolean ifTrue: [text contents: ''].
	
	text moveCursorTo: aNumber.
	^ cmd
]
