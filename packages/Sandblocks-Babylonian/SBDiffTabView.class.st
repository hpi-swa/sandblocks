Class {
	#name : #SBDiffTabView,
	#superclass : #SBTabView,
	#instVars : [
		'isShowingDiff'
	],
	#category : #'Sandblocks-Babylonian'
}

{ #category : #nil }
SBDiffTabView >> addButton [

	^ SBButton new
		icon: (SBIcon iconPlus
				size: 7.0 sbScaled;
				color: (Color green))
			do: [self addTab];
		makeSmall;
		cornerStyle: #squared;
		vResizing: #spaceFill;
		balloonText: 'Add';
		cellGap: -1.0 sbScaled;
		layoutInset: (4.0 @ 4.0) sbScaled
]

{ #category : #callbacks }
SBDiffTabView >> artefactSaved: aMethodBlock [

	aMethodBlock = self containingArtefact ifTrue: [self updateTabNames].

	(aMethodBlock = self containingArtefact and: [self isShowingDiff]) 
		ifTrue: [self updateSelectedTab]
]

{ #category : #diffing }
SBDiffTabView >> buildDiffBlockFrom: aNamedBlock to: anotherNamedBlock given: aDiffText [

	(aNamedBlock == anotherNamedBlock) ifTrue: [^ aNamedBlock block vResizing: #spaceFill].
	
	^ SBTextBubble multiLine 
		vResizing: #spaceFill;
		contents: aDiffText, 
			 (Text fromString: 
				'', Character cr,
				'==========', Character cr,
				(aNamedBlock name)) 
]

{ #category : #ui }
SBDiffTabView >> buildTabs [

	self addMorphBack: (SBRow new
		addAllMorphsBack: (self namedBlocks collect: [:block | self asTabButton: block]);
		name: #tabs;
		addMorphBack: self addButton;
		addMorphFront: self diffButton;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #shrinkWrap)
]

{ #category : #ui }
SBDiffTabView >> buildView [

	self addMorphBack:  ((self isShowingDiff 
		ifTrue: [self diffForSelected]
		ifFalse: [self activeBlock])
			hResizing: #spaceFill)
]

{ #category : #ui }
SBDiffTabView >> diffButton [

	^ SBButton new
		icon: (SBIcon iconCodeFork size: 12.0)
			do: [self toggleDiffView];
		makeSmall;
		balloonText: 'Toggle diff to others';
		vResizing: #spaceFill;
		cornerStyle: #squared;
		cellGap: -1.0 sbScaled;
		layoutInset: (4.0 @ 3.0) 
]

{ #category : #diffing }
SBDiffTabView >> diffForSelected [

	| diffs |
	diffs := self paddedDiffTexts.

	"Some blocks are only able to print themselves with a block as parent (eg block bodies). 
	Thats why we don't use a SBRow here"
	^ SBBlock new
		changeTableLayout;
		listDirection: #leftToRight;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		addAllMorphsBack: (self namedBlocks withIndexCollect: [:aNamedBlock :i | 
			self buildDiffBlockFrom: aNamedBlock to: self active given: (diffs at: i)])
]

{ #category : #initialization }
SBDiffTabView >> initialize [

	super initialize.
	
	isShowingDiff := false.
	self hResizing: #spaceFill.
]

{ #category : #accessing }
SBDiffTabView >> isShowingDiff [

	^ isShowingDiff
]

{ #category : #accessing }
SBDiffTabView >> isShowingDiff: aBoolean [ 

	isShowingDiff := aBoolean
]

{ #category : #diffing }
SBDiffTabView >> paddedDiffTexts [

	| diffs maxLines |
	diffs := self namedBlocks collect: [:aNamedBlock |  
		(TextDiffBuilder 
				from: (self sourceStringFor: aNamedBlock) 
				to: (self sourceStringFor: self active)) buildDisplayPatch].
			
	maxLines := (diffs collect: [:aText | aText lineCount]) max.
	
	^ diffs collect: [:aText | | paddedText |
		paddedText := aText. 
		(maxLines - aText lineCount) timesRepeat: [paddedText := paddedText, ('', Character cr)]. 
		paddedText]
]

{ #category : #diffing }
SBDiffTabView >> sourceStringFor: aNamedBlock [

	^ aNamedBlock block isBlockBody
		ifFalse: [aNamedBlock block sourceString]
		ifTrue: [ (aNamedBlock block statements collect: #sourceString)
				ifEmpty: ['']
				ifNotEmpty: [:theStatements | theStatements fold: [:a :b | a, Character cr, b]]]
]

{ #category : #accessing }
SBDiffTabView >> tabs [

	^ (self submorphNamed: #tabs) submorphs viewAllButFirstAndLast
]

{ #category : #actions }
SBDiffTabView >> toggleDiffView [

	self isShowingDiff: self isShowingDiff not.
	self view delete.
	self buildView.
]
