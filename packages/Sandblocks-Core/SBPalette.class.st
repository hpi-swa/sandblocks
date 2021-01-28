Class {
	#name : #SBPalette,
	#superclass : #SBBlock,
	#instVars : [
		'stream',
		'content'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBPalette >> addBlock: aString as: aBlock [

	content
		"addMorphBack: (SBStringMorph new contents: aString);"
		addMorphBack: (self container: aBlock)
]

{ #category : #'as yet unclassified' }
SBPalette >> addSectionHeader: aString [

	content submorphCount > 0 ifTrue: [content addMorphBack: (Morph new color: Color transparent; height: 16)].
	content addMorphBack: (SBStringMorph new contents: aString; bold).
	content addMorphBack: (Morph new color: Color transparent; height: 4)
]

{ #category : #'as yet unclassified' }
SBPalette >> childSandblocksDo: aBlock [

	content submorphsDo: [:m | m isSandblock ifTrue: [aBlock value: m]]
]

{ #category : #'as yet unclassified' }
SBPalette >> container: aBlock [

	^ SBPalettePreviewContainer new
		methodClass: nil;
		addMorphBack: aBlock
]

{ #category : #'as yet unclassified' }
SBPalette >> grammarHandler [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SBPalette >> initialize [

	super initialize.
	
	self
		addMorphBack: (ScrollPane new
			hResizing: #shrinkWrap;
			vResizing: #spaceFill);
		hResizing: #shrinkWrap;
		vResizing: #rigid;
		changeTableLayout;
		height: 200;
		layoutInset: 8;
		attachDecorator: SBMoveDecorator new;
		attachDecorator: SBResizableDecorator new.
	
	self firstSubmorph scroller
		addMorphBack: (content := SBColumn new
			useAlgebraLayout;
			minimumWidth: 300;
			layoutInset: 8)
]

{ #category : #'as yet unclassified' }
SBPalette >> layoutCommands [

	^ SBAlgebraCommand container
		morph: self;
		data: (self submorphs collect: #layoutCommands separatedBy: [SBAlgebraCommand hardLine])
]

{ #category : #'as yet unclassified' }
SBPalette >> newNullBlock [

	^ SBUnknown new grammarHandler: self grammarHandler
]

{ #category : #'as yet unclassified' }
SBPalette >> newNullBlock: aString [

	^ self newNullBlock label: aString
]

{ #category : #'as yet unclassified' }
SBPalette >> pickUp: anEvent [

	" forward directly to our palette contents "
	| morphs |
	morphs := content morphsAt: anEvent position.
	morphs size > 1 ifTrue: [(morphs at: morphs size - 1) pickUp: anEvent]
]
