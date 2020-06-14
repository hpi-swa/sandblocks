Class {
	#name : #SBTutorialStep,
	#superclass : #SBBlock,
	#instVars : [
		'shortcutsList',
		'steps',
		'title',
		'setup'
	],
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'as yet unclassified' }
SBTutorialStep class >> step01Method [

	Transcript showln: 'Hello world!!'
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovement: anEditor [

	| method |
	anEditor openMorphInView: (SBTutorialStep new
		title: '01 Movement';
		addIntroText: 'Here we get to know the basics to move around the system. The text is gonna be rather long so make sure we can wrap properly.';
		addAction: #selectNext;
		addAction: #selectPrevious;
		addAction: #selectUp;
		addAction: #selectDown;
		setup: anEditor
			do: [:step |
				method := step createStepMethod: [Transcript showln: 'Hello world!!'] in: anEditor.
				step
					addStep: 'Select the last block of this method'
					checkCondition: [:editor | editor selection = method lastDeepChild]];
		yourself)
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovementMethod [ Transcript showln: 'Hello world!!'
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addAction: anActionSymbol [

	shortcutsList addMorphBack: (SBButton new
		label: anActionSymbol
		shortcut: (SBEditor anyShortcutForAction: anActionSymbol)
		do: [self selectionDo: anActionSymbol])
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addIntroText: aString [

	self
		addMorph: (SBMultilineOwnTextMorph new
			contents: aString;
			maxWidth: self maxTextWidth)
		asElementNumber: 2
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addStep: aString checkCondition: aBlock [

	steps addMorphBack: (SBRow new
		addMorphBack: (SBCheckbox new setProperty: #checkBlock toValue: aBlock);
		addMorphBack: (SBMultilineOwnTextMorph new
			contents: aString;
			maxWidth: self maxTextWidth))
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> canCopy [

	^ false
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> checkConditions [

	steps submorphsDo: [:step |
		step firstSubmorph value: ((step firstSubmorph valueOfProperty: #checkBlock) value: self sandblockEditor)]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> childSandblocksDo: aBlock [

	
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> createStepMethod: aBlock in: anEditor [

	| selector |
	selector := thisContext sender method homeMethod selector allButLast, 'Method'.
	self class class compile: (selector, ' '), aBlock sourceString allButFirst allButLast.
	^ anEditor open: self class class >> selector asSymbol
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> drawnColor [

	^ Color veryDarkGray
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> example [

	SBMorphExample
		setUp: [
			SBTutorialStep new
				title: '01 Movement';
				addIntroText: 'Here we get to know the basics to move around the system. The text is gonna be rather long so make sure we can wrap properly.';
				addAction: #selectNext;
				addAction: #selectPrevious;
				addAction: #selectUp;
				addAction: #selectDown;
				addStep: 'Select the last block of this method' checkCondition: [:editor | editor selected = self];
				fullBounds;
				yourself]
		cases: {
			(SBMorphExampleCase name: 'example 1' caseBlock: [:m | m])
		}
		extent: 518 @ 262
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> initialize [

	super initialize.
	self
		attachDecorator: (SBMoveDecorator new
			preventOcclusion: true;
			yourself);
		changeTableLayout;
		layoutInset: 8;
		cellGap: 8;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new addMorphBack: (title := SBStringMorph new large));
		addMorphBack: (shortcutsList := SBRow new cellGap: 8);
		addMorphBack: (steps := SBColum new);
		addMorphBack: (SBRow new
			hResizing: #spaceFill;
			cellGap: 8;
			changeTableLayout;
			addMorphBack: (SBButton new
				balloonText: 'Reset Task';
				icon: SBIcon iconRefresh shortcut: nil do: [self reset]);
			addMorphBack: (Morph new
				hResizing: #spaceFill;
				height: 0);
			addMorphBack: (SBButton new
				balloonText: 'Previous Task';
				icon: SBIcon iconArrow_left shortcut: nil do: [self next]);
			addMorphBack: (SBButton new
				balloonText: 'Next Task';
				icon: SBIcon iconArrow_right shortcut: nil do: [self previous]))
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> maxTextWidth [

	^ 400
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> next [

	
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> object [

	^ nil
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> outOfWorld: aWorld [

	super outOfWorld: aWorld.
	self unregister
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> previous [

	
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset [

	| editor |
	editor := self sandblockEditor.
	editor closeAll.
	editor openMorphInView: self.
	setup value: self
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> selectionDo: aSymbol [

	self sandblockEditor selection perform: aSymbol
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> setup: anEditor do: aBlock [

	setup := aBlock.
	steps removeAllMorphs.
	aBlock value: self.
	anEditor when: #selectionChanged send: #checkConditions to: self
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> title: aString [

	title contents: aString
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> unregister [

	self sandblockEditor removeActionsWithReceiver: self
]
