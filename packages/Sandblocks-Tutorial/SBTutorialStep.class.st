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

	self progress removeKey: aSymbol ifAbsent: []
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepBasicMessageSend: anEditor [

	SBTutorialStep new
		title: 'Basic Message Send';
		addIntroText: 'The editor has a separate input mode that allows typing on the keyboard as normal. Let''s see how to use it for message sends.';
		addAction: #wrapInMessageSend;
		addAction: #endInput;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [self assert: 1024 = 2] in: anEditor.
				step addStep: 'Select the 2' checkCondition: [:editor | editor selection contents = '2'].
				step
					addStep: 'Press space to send a message to your selection, then type raisedTo:. Press enter to accept an autocompletion.'
					checkCondition: [:editor |
						method statements first arguments first arguments first selector = 'raisedTo:'].
				step
					addStep: 'Finally, type 10 in the now opened field and press escape to exit the input mode.'
					checkCondition: [:editor |
						method statements first arguments first arguments first arguments first contents = '10']]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepBasicMessageSendMethod [ self assert: 1024 = 2
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
SBTutorialStep class >> stepInputMode: anEditor [

	SBTutorialStep new
		title: 'Input mode';
		addIntroText: 'The input mode is used to edit any leaf node''s data.';
		addAction: #startInputAtStart;
		addAction: #startInputAtEnd;
		addAction: #startInputSubstituting;
		addAction: #endInput;
		addAction: #changeToUnknown;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [
						self assert: 1234 = 234.
						self assert: 'This is a rather long string where it would be annoying to have the cursor at the '.
						self assert: (9 + 9) = 7.
						self assert: (9 + 9) = Morph new]
					in: anEditor.
				step
					addStep: 'To enter input mode at the start of a node, press i. Change the 234 to a 1234 by pressing i, then 1, then escape.'
					checkCondition: [:editor |
						method statements first arguments first arguments first contents = '1234'].
				step
					addStep: 'You can enter input mode at the end of a long text, too. Press a on the long string and add the missing word "start".'
					checkCondition: [:editor |
						method statements second arguments first contents includesSubstring: 'start'].
				step
					addStep: 'You can also replace the contents of an element and start editing right away.
Press s on the 7 and change it to an 18.'
					checkCondition: [:editor |
						method statements third arguments first arguments first contents = '18'].
				step
					addStep: 'Finally, you can change a selection of elements in one go with c.
Select the `Morph new` message send using shift+k and press c.
Then change it to 18.'
					checkCondition: [:editor |
						method statements fourth arguments first arguments first contents = '18']]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepInputModeMethod [

	self assert: 1234 = 234.
	self assert: 'This is a rather long string where it would be annoying to have the cursor at the start'.
	self assert: (9 + 9) = 18.
	self assert: (9 + 9) = 18
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovement: anEditor [

	SBTutorialStep new
		title: 'Movement';
		addIntroText: 'Hey! First we''ll look at moving your cursor. You can click on things, but try to only use your keyboard to get used to it. Like in vim, hjlk moves your cursor around.

Note that you always undo accidental changes with u (and redo with U).';
		addAction: #selectNext;
		addAction: #selectPreviousGroup;
		addAction: #selectUp;
		addAction: #selectNextGroup;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [ | y x |
						(true & false not) & nil isNil ifFalse: [52 squared].
						y := self size + super size.
						#($a #a 1 1.0) do: [:each |
							Transcript
								show: each class name;
								show: ' '].
						^ x < y]
					in: anEditor.
				step
					addStep: 'Select the empty string in the Transcript show cascade'
					checkCondition: [:editor |
						editor selection = method body statements third arguments first statements first messages second arguments first].
				step
					addStep: 'Select the 52 in the ifFalse: block'
					checkCondition: [:editor |
						editor selection = method body statements first arguments first statements first receiver].
				step
					addStep: 'Select the character $a'
					checkCondition: [:editor |
						editor selection = method body statements third receiver submorphs first]]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepMovementMethod [ | y x |
true & false not & nil isNil
		ifFalse: [52 squared].
	y := self size + super size.
	#($a #a 1 1.0)
		do: [:each | Transcript show: each class name;
				 show: ' '].
	^ x < y
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepSelection: anEditor [

	SBTutorialStep new
		title: 'Selection';
		addIntroText: 'So far, we''ve only selected leaf nodes (i.e. nodes without children). Let''s try selecting larger groups.';
		addAction: #selectUp;
		addAction: #selectDown;
		addAction: #deleteBlock;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [ | y x |
						(true & false not) & nil isNil ifFalse: [52 squared].
						y := self size + super size.
						#($a #a 1 1.0) do: [:each |
							Transcript
								show: each class name;
								show: ' '].
						^ x < y]
					in: anEditor.
				step
					addStep: 'First, select the block argument :each in the 2nd to last line.'
					checkCondition: [:editor |
						editor selection = method body statements third arguments first bindings first].
				step
					addStep: 'Then use Shift+K to enlargen your selection to select the fuil do: message send. You can use Shift+J to go down again.'
					checkCondition: [:editor | editor selection = method body statements third].
				step
					addStep: 'Finally, as an example use x to delete the full block.'
					checkCondition: [:editor |
						method body statements noneSatisfy: [:s | s selector = 'do:']]]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepSelectionMethod [ | y x |
true & false not & nil isNil
		ifFalse: [52 squared].
	y := self size + super size.
	#($a #a 1 1.0)
		do: [:each | Transcript show: each class name;
				 show: ' '].
	^ x < y
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepSwapping: anEditor [

	SBTutorialStep new
		title: 'Swapping';
		addIntroText: 'In a text editor, you usually move code by copy-pasting. Here, you can also use swap commands directly.';
		addAction: #swapLeft;
		addAction: #swapRight;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [
					{1. 2. 3. 6. 4. 5}.
					self assert: (10 raisedTo: 2) = 1024] in: anEditor.
				step addStep: 'Select the 6 in the array' checkCondition: [:editor | editor selection contents = '6'].
				step
					addStep: 'Using L, move it to the end of the array.'
					checkCondition: [:editor |
						method body statements first lastSubmorph contents = '6'].
				step
					addStep: 'Select the 2 in the message send below the array.'
					checkCondition: [:editor |
						editor selection contents = '2' and: [
							editor selection containingStatement = method body statements second]].
				step
					addStep: 'Using H, swap it with the number 10.'
					checkCondition: [:editor |
						method body statements second arguments first receiver receiver contents = '2']]
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> stepSwappingMethod [ {1. 2. 3. 6. 4. 5}.
	self assert: (10 raisedTo: 2)
			= 1024
]

{ #category : #'as yet unclassified' }
SBTutorialStep class >> tutorialSteps [

	^ {#stepMovement:. #stepDeleting:. #stepSelection:. #stepSwapping:. #stepBasicMessageSend:. #stepInputMode:}
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
		cellGap: 8;
		addMorphBack: (SBCheckbox new
			setProperty: #checkBlock toValue: aBlock;
			value: (self class checkIsComplete: selector index: steps submorphCount + 1);
			yourself);
		addMorphBack: (SBMultilineOwnTextMorph new
			contents: aString;
			maxWidth: self maxTextWidth))
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> artefactChanged: anArtefact [

	self checkConditions
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
		attachDecorator: SBMoveDecorator new;
		changeTableLayout;
		layoutInset: 8;
		cellGap: 16;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new addMorphBack: (title := SBStringMorph new large));
		addMorphBack: (shortcutsList := SBRow new cellGap: 8);
		addMorphBack: (steps := SBColum new
			cellGap: 8;
			yourself);
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

	self class resetProgressFor: selector.
	self reset: self sandblockEditor
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
