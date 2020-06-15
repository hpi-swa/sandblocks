Class {
	#name : #SBTutorialStep,
	#superclass : #SBBlock,
	#instVars : [
		'shortcutsList',
		'steps',
		'title',
		'setup',
		'selector',
		'buttons'
	],
	#classVars : [
		'Progress'
	],
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'as yet unclassified' }
SBTutorialStep class >> checkIsComplete: aMethodSymbol index: aNumber [

	^ self progress at: aMethodSymbol ifPresent: [:list | list includes: aNumber] ifAbsent: [false]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> markStepCompleted: selector index: index [

	(self progress at: selector ifAbsentPut: [Set new]) add: index
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> progress [

	^ Progress ifNil: [Progress := Dictionary new]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> resetProgressFor: aSymbol [

	self progress removeKey: aSymbol
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepDeleting: anEditor [

	SBTutorialStep new
		title: 'Deleting';
		addAction: #deleteBlock;
		addAction: #pasteAbove;
		addAction: #pasteBelow;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [{1. 2. 6. 3. 4. 5}] in: anEditor.
				step
					addStep: 'Delete the 6 in the list by pressing x'
					checkCondition: [:editor |
						method body statements first submorphs noneSatisfy: [:el | el contents = '6']].
				step
					addStep: 'A deleted element is automatically copied. Paste it at the end of the list using p.'
					checkCondition: [:editor |
						method body statements first lastSubmorph contents = '6'].
				step
					addStep: 'Paste the 6 again at the start of the list using P'
					checkCondition: [:editor |
						method body statements first firstSubmorph contents = '6']]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepDeletingMethod [ {1. 2. 6. 3. 4. 5}
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovement: anEditor [

	SBTutorialStep new
		title: 'Movement';
		addIntroText: 'Here we get to know the basics to move around the system. The text is gonna be rather long so make sure we can wrap properly.';
		addAction: #selectNext;
		addAction: #selectPrevious;
		addAction: #selectUp;
		addAction: #selectDown;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [Transcript showln: 'Hello world!!'] in: anEditor.
				step
					addStep: 'Select the last block of this method'
					checkCondition: [:editor | editor selection = method lastDeepChild]]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovementMethod [ Transcript showln: 'Hello world!!'
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> tutorialSteps [

	^ {#stepMovement:. #stepDeleting:}
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
		addMorphBack: (SBCheckbox new
			setProperty: #checkBlock toValue: aBlock;
			value: (self class checkIsComplete: selector index: steps submorphCount + 1);
			yourself);
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

	steps submorphs withIndexDo: [:step :index | | checkbox |
		checkbox := step firstSubmorph.
		checkbox value ifFalse: [
			([
				(checkbox valueOfProperty: #checkBlock) value: self sandblockEditor] on: Error do: [:error |
				error signal.
				false]) ifTrue: [
				checkbox value: true.
				self class markStepCompleted: selector index: index]]]
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
		addMorphBack: (buttons := SBRow new
			hResizing: #spaceFill;
			cellGap: 8;
			changeTableLayout;
			addMorphBack: (SBButton new
				balloonText: 'Reset Task';
				icon: SBIcon iconRefresh shortcut: nil do: [self reset]);
			addMorphBack: (Morph new
				hResizing: #spaceFill;
				height: 0))
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> maxTextWidth [

	^ 400
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> next [

	| nextSelector |
	nextSelector := self class tutorialSteps at: self stepIndex + 1.
	SBTutorialStep perform: nextSelector with: self sandblockEditor
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

	| previousSelector |
	previousSelector := self class tutorialSteps at: self stepIndex - 1.
	SBTutorialStep perform: previousSelector with: self sandblockEditor
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset [

	self reset: self sandblockEditor.
	self class resetProgressFor: selector
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset: anEditor [

	steps removeAllMorphs.
	anEditor closeAll.
	anEditor openMorphInView: self.
	setup value: self.
	self extent: 0 @ 0.
	anEditor when: #selectionChanged send: #checkConditions to: self
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> selectionDo: aSymbol [

	self sandblockEditor selection perform: aSymbol
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> setup: anEditor do: aBlock [

	selector := thisContext sender method homeMethod selector.
	setup := aBlock.
	self reset: anEditor.
	self stepIndex > 1 ifTrue: [
		buttons addMorphBack: (SBButton new
			balloonText: 'Previous Task';
			icon: SBIcon iconArrow_left shortcut: nil do: [self previous])].
	self stepIndex < self class tutorialSteps size ifTrue: [
		buttons addMorphBack: (SBButton new
			balloonText: 'Next Task';
			icon: SBIcon iconArrow_right shortcut: nil do: [self next])]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> stepIndex [

	^ self class tutorialSteps indexOf: selector
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> title: aString [

	title contents: aString
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> unregister [

	self sandblockEditor removeActionsWithReceiver: self
]
