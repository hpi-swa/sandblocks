Class {
	#name : #SBPaletteContainer,
	#superclass : #SBBlock,
	#instVars : [
		'stream',
		'content',
		'categories'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPaletteContainer class >> context [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPaletteContainer class >> matchesBlock: aBlock [

	^ true
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> addBlock: aString as: aBlock [

	content
		"addMorphBack: (SBStringMorph new contents: aString);"
		addMorphBack: (self container: aBlock)
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> addHeader: aString [

	categories submorphs ifNotEmpty: [
		categories addMorphBack: (Morph new
			color: Color transparent;
			height: 8)].
	categories addMorphBack: (SBStringMorph new
		contents: aString;
		bold)
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> addSectionHeader: aString [

	| header |
	header := SBStringMorph new
		contents: aString;
		bold.
	content hasSubmorphs ifTrue: [
		content addMorphBack: (Morph new
			color: Color transparent;
			height: 16)].
	content addMorphBack: header.
	categories addMorphBack: (SBStringMorph new
		contents: aString;
		on: #click send: #scrollToSection:event:morph: to: self withValue: header).
	content addMorphBack: (Morph new
		color: Color transparent;
		height: 4)
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> container: aBlock [

	^ SBPalettePreviewContainer new
		methodClass: nil;
		addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> grammarHandler [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> initialize [

	super initialize.
	
	self
		addMorphBack: (categories := SBColumn new layoutInset: 4);
		addMorphBack: (ScrollPane new
			hResizing: #spaceFill;
			vResizing: #spaceFill);
		layoutInset: 0;
		cellGap: 8;
		hResizing: #shrinkWrap;
		vResizing: #rigid;
		changeTableLayout;
		height: 300;
		width: 350;
		listDirection: #leftToRight;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new.
	
	self lastSubmorph scroller addMorphBack: (content := SBColumn new
		useAlgebraLayout;
		minimumWidth: 300;
		cellGap: 4;
		layoutInset: 8)
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> newNullBlock [

	^ SBUnknown new grammarHandler: self grammarHandler
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> newNullBlock: aString [

	^ self newNullBlock label: aString
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> pickUp: anEvent [

	" forward directly to our palette contents "
	| morphs |
	morphs := content morphsAt: anEvent position.
	morphs size > 1 ifTrue: [(morphs at: morphs size - 1) pickUp: anEvent]
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> scrollToSection: aBlock event: anEvent morph: aMorph [

	content owner owner vScrollBar setValue: aBlock top
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> selectedBlock [

	^ nil
]
