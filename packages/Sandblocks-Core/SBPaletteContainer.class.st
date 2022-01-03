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

	| block |
	"addMorphBack: (SBStringMorph new contents: aString);"
	block := (aBlock isInlineBlock and: [aBlock factory rootRuleName = aBlock type])
		ifTrue: [aBlock childSandblocks first]
		ifFalse: [aBlock].
	content addMorphBack: (self container: block label: aString)
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
SBPaletteContainer >> container: aBlock label: aString [

	^ SBPalettePreviewContainer new
		methodClass: nil;
		label: aString;
		addMorphBack: (self markCopyPlaceholder: aBlock)
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> grammarHandler [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> initialize [

	super initialize.
	
	self
		addMorphBack: (categories := SBColumn new
			layoutInset: 4;
			cellPositioning: #topLeft);
		addMorphBack: (ScrollPane new
			color: Color transparent;
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
	
	self lastSubmorph scroller
		addMorphBack: (content := SBColumn new
			useAlgebraLayout;
			minimumWidth: 300;
			width: 300;
			cellGap: 4;
			layoutInset: 8);
		changeTableLayout
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> markCopyPlaceholder: aBlock [

	(aBlock nextBlockThat: [:m | m isUnknown]) ifNotNil: [:m |
		m setProperty: #copyPlaceholder toValue: true].
	^ aBlock
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> newNullBlock [

	^ SBUnknown new
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> newNullBlock: aString [

	^ self newNullBlock label: aString
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> objectInterface [

	^ SBInterfaces always
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

{ #category : #'as yet unclassified' }
SBPaletteContainer >> specialDropCommand: aBlock [

	^ SBDeleteCommand new target: aBlock
]
