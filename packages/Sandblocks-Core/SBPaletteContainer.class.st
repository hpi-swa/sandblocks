Class {
	#name : #SBPaletteContainer,
	#superclass : #SBBlock,
	#instVars : [
		'stream',
		'content',
		'categories',
		'search'
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
SBPaletteContainer >> initialize [

	super initialize.
	
	self
		addMorphBack: (categories := SBColumn new
			layoutInset: 4;
			cellPositioning: #topLeft);
		addMorphBack: (SBColumn new
			addMorphBack: (search := SBTextBubble new
				placeholderText: 'Search ...';
				when: #contentsChanged send: #updateSearch to: self;
				layoutInset: 2;
				hResizing: #spaceFill);
			addMorphBack: (ScrollPane new
				color: Color transparent;
				hResizing: #spaceFill;
				vResizing: #spaceFill);
			vResizing: #spaceFill;
			hResizing: #spaceFill;
			cellGap: 4;
			layoutInset: (SBEdgeInsets top: 4));
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
	
	self lastSubmorph lastSubmorph scroller
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
SBPaletteContainer >> selectedBlock [

	^ nil
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> specialDropCommand: aBlock [

	^ SBDeleteCommand new target: aBlock
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> submorph: aMorph matchesQuery: aString [

	aMorph allMorphsDo: [:m |
		((m respondsTo: #textContents) and: [m textContents asLowercase includesSubstring: aString]) ifTrue: [^ true].
		((m respondsTo: #placeholderText) and: [m placeholderText asLowercase includesSubstring: aString]) ifTrue: [^ true].
		m balloonText ifNotNil: [:text | (text asLowercase includesSubstring: aString) ifTrue: [^ true]]].
	^ false
]

{ #category : #'as yet unclassified' }
SBPaletteContainer >> updateSearch [

	| query |
	query := search contents asLowercase.
	content submorphsDo: [:container |
		container submorphsDo: [:m | | show |
			show := query isEmpty or: [self submorph: m matchesQuery: query].
			m
				visible: show;
				disableLayout: show not]].
	content layoutChanged
]
