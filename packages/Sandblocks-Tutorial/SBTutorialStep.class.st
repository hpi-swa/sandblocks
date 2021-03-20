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

{ #category : #progress }
SBTutorialStep class >> checkIsComplete: aMethodSymbol index: aNumber [

	^ self progress at: aMethodSymbol ifPresent: [:list | list includes: aNumber] ifAbsent: [false]
]

{ #category : #progress }
SBTutorialStep class >> hasProgress: aSymbol [

	^ self progress at: aSymbol ifPresent: [:list | true] ifAbsent: [false]
]

{ #category : #progress }
SBTutorialStep class >> markStepCompleted: selector index: index [

	(self progress at: selector ifAbsentPut: [Set new]) add: index
]

{ #category : #opening }
SBTutorialStep class >> open [

	SBTutorialStep perform: self tutorialSteps first with: SBEditor open
]

{ #category : #progress }
SBTutorialStep class >> progress [

	^ Progress ifNil: [Progress := Dictionary new]
]

{ #category : #progress }
SBTutorialStep class >> resetAllProgress [
	"self resetAllProgress"

	Progress := nil
]

{ #category : #progress }
SBTutorialStep class >> resetProgressFor: aSymbol [

	self progress removeKey: aSymbol ifAbsent: []
]

{ #category : #opening }
SBTutorialStep class >> resume [

	self resumeIn: SBEditor open
]

{ #category : #opening }
SBTutorialStep class >> resumeIn: anEditor [

	SBTutorialStep perform: (self tutorialSteps detect: [:step | (self hasProgress: step) not] ifNone: [self tutorialSteps first]) with: anEditor
]

{ #category : #steps }
SBTutorialStep class >> stepAdvancedMessageSends: anEditor [

	SBTutorialStep new
		title: 'Advanced Message Sends';
		addIntroText: 'Let''s consider a complex example. Try to change the first expression to look like the second. Here, we will guide you through the steps once more. Maybe try resetting the tutorial after and try it again without following the steps exactly!';
		addAction: #addElement;
		addAction: #addElement;
		addAction: #promptAction;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [
						SBLabel text: ['Try to change this:'].
						{42. 12} do: [:num | Transcript showln: num].
						SBLabel text: ['Into this:'].
						{42. 12} with: {54. 32} do: [:num :num2 | Transcript showln: {num. num2}]]
					in: anEditor.
				step
					addStep: 'Select the message part do: and hit * to insert another part before it. Then type with: and hit tab to focus the next hole.'
					checkCondition: [:editor | method statements second selector = 'with:do:'].
				step
					addStep: 'Type { to create an array in the hole and add the numbers 54 and 32'
					checkCondition: [:editor |
						method statements second arguments first in: [:array |
							array isArrayBlock and: [
								(array submorphs collect: #contents) = {'54'. '32'}]]].
				step
					addStep: 'Move on to the block. Select the first statement and press O to create a new statement above. Then type :num2 to turn it into a block binding.'
					checkCondition: [:editor |
						method statements second arguments in: [:args | args size > 1 and: [args second bindings size = 2]]].
				step
					addStep: 'Finally, turn the number in the showln: to an array using { and add another element after it using +.'
					checkCondition: [:editor |
						method statements second arguments in: [:args |
							args size > 1 and: [
								args second statements first in: [:msg |
									msg isMessageSend and: [
										msg arguments first in: [:array |
											array isArrayBlock and: [
												(array submorphs collect: #contents) = {'num'. 'num2'}]]]]]]]]
]

{ #category : #steps }
SBTutorialStep class >> stepAssignments: anEditor [

	SBTutorialStep new
		title: 'Assignments';
		addAction: #wrapInAssignment;
		addAction: #extractVariable;
		addAction: #insertStatementBelow;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					42 squared.
					7 > 8 ifTrue: [Transcript showln: 'hi']]
				in: anEditor.
			step
				addStep: 'Wrap the expression `42 squared` in an assignment by selecting the expression (use <#selectUp>) and press <#wrapInAssignment>. Then type a name.'
				checkCondition: [:editor | method statements first isAssignment].
			step
				addStep: 'Hit save (<#save>) and declare the variable as block local.'
				checkCondition: [:editor | method body temporaries notEmpty].
			step
				addStep: 'Next, create a new statement by pressing <#insertStatementBelow>. Type the name `var` and press : again while still in input mode. Assign 5 to this variable.'
				checkCondition: [:editor | method statements anySatisfy: [:s | s isAssignment and: [s binding contents = 'var']]].
			step
				addStep: 'The last way to create an assignment is to extract an expression. Select the 7>8 and press <#extractVariable>. Name the new variable comp.'
				checkCondition: [:editor | method statements anySatisfy: [:s | s isMessageSend and: [s receiver in: [:r | r isName and: [r contents = 'comp']]]]]]
]

{ #category : #steps }
SBTutorialStep class >> stepBasicMessageSend: anEditor [

	SBTutorialStep new
		title: 'Basic Message Send';
		addIntroText: 'The editor has a separate input mode that allows typing on the keyboard as normal. Let''s see how to use it for message sends.';
		addAction: #wrapInMessageSend;
		addAction: #endInput if: anEditor inputIsDefault not;
		setup: anEditor do: [:step | | method |
			method := step createStepMethod: [self assert: 1024 = 2] in: anEditor.
			step addStep: 'Select the 2 using <#selectLast>, which selects the last block in a method.' checkCondition: [:editor | editor selection contents = '2'].
			step
				addStep: 'Press <#wrapInMessageSend> to send a message to your selection, then type raisedTo:. Use <#focusNextSuggestion> and <#focusPreviousSuggestion> to move in the suggestions list and press enter to accept an autocompletion.'
				checkCondition: [:editor | method statements first arguments first arguments first selector = 'raisedTo:'].
			step
				addStep: 'Finally, type 10 in the now opened field', (anEditor inputIsDefault
					ifTrue: ['.']
					ifFalse: [' and press escpae to exit the input mode.'])
				checkCondition: [:editor | method statements first arguments first arguments first arguments first contents = '10']]
]

{ #category : #steps }
SBTutorialStep class >> stepCascade: anEditor [

	SBTutorialStep new
		title: 'Cascades';
		addIntroText: 'Let''s format this morph construction code in a cascade. Remember you can press <#undo> to undo when anything goes wrong (and <#redo> to redo).';
		addAction: #wrapInCascade;
		addAction: #deleteAround;
		addAction: #pasteBelow;
		setup: anEditor
			do: [:step | | method |
				method := step
					createStepMethod: [ | m |
						m := Morph new.
						m changeTableLayout.
						m hResizing: #shrinkWrap.
						m vResizing: #shrinkWrap]
					in: anEditor.
				step
					addStep: 'First, multiselect the changeTableLayout, hResizing:, and vResizing: message sends.'
					checkCondition: [:editor |
						editor mode = #selection and: [
							editor multiSelection size = 3 and: [
								editor multiSelection allSatisfy: [:m | m isMessageSend or: [m isMessagePart]]]]].
				step
					addStep: 'Create a cascade from your multiselection by pressing <#wrapInCascade>'
					checkCondition: [:editor | method statements second isCascade].
				step
					addStep: 'Let''s also move the cascade around our `Morph new` expression. The fastest way to do so is to select the receiver of the cascade `m` and press <#deleteAround>, which deletes and copies the element around your selection.'
					checkCondition: [:editor |
						method statements second in: [:m | m isBinding and: [m contents = 'm']]].
				step
					addStep: 'Next, select the full `Morph new` block and press <#pasteBelow> to paste the just copied surronding element around our selection.'
					checkCondition: [:editor | method statements first expression isCascade]]
]

{ #category : #steps }
SBTutorialStep class >> stepDeleting: anEditor [

	SBTutorialStep new
		title: 'Deleting';
		addAction: #deleteBlock;
		addAction: #pasteAbove;
		addAction: #pasteBelow;
		setup: anEditor do: [:step | | method |
			method := step createStepMethod: [{1. 2. 6. 3. 4. 5}] in: anEditor.
			step
				addStep: 'Delete the 6 in the list by pressing <#deleteBlock>'
				checkCondition: [:editor | method body statements first submorphs noneSatisfy: [:el | el contents = '6']].
			step
				addStep: 'A deleted element is automatically copied. Paste it at the end of the list by walking to the 5 and pressing <#pasteBelow>.'
				checkCondition: [:editor | method body statements first lastSubmorph contents = '6'].
			step
				addStep: 'Paste the 6 again at the start of the list by walking to the 1 and pressing <#pasteAbove>'
				checkCondition: [:editor | method body statements first firstSubmorph contents = '6']]
]

{ #category : #steps }
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

{ #category : #steps }
SBTutorialStep class >> stepLists: anEditor [

	SBTutorialStep new
		title: 'Lists';
		addIntroText: 'Many elements act as lists, for example arrays, statements in blocks, or even message sends.';
		addAction: #addElement;
		addAction: #insertElementAfter;
		addAction: #insertElementBefore;
		setup: anEditor do: [:step | | method |
			method := step createStepMethod: [{3. 4. 5}] in: anEditor.
			step
				addStep: 'Select the array itself using <#selectUp>'
				checkCondition: [:editor | editor selection isArrayBlock].
			step
				addStep: 'You can append an element to a list by pressing <#addElement>
Append 6 to the array by pressing <#addElement> then typing 6.'
				checkCondition: [:editor | method statements first lastSubmorph contents = '6'].
			step
				addStep: 'Add a 1 at the start of the array by selecting the 3 and pressing <#insertElementBefore>'
				checkCondition: [:editor | method statements first firstSubmorph contents = '1'].
			step
				addStep: 'Finally, to insert an element after the current, use <#insertElementAfter> and type 2.'
				checkCondition: [:editor | method statements first submorphs second contents = '2'].
			step
				addStep: 'While <#insertElementBefore> and <#insertElementAfter> will always be adjacent to the current selection, for statements, there is a special type of insert. Create an empty statement above the array using <#insertStatementAbove>.'
				checkCondition: [:editor | method statements size > 1 and: [method statements second isArrayBlock]].
			step
				addStep: 'Create an empty statement below the array by first moving the cursor to any number in the array and pressing <#insertStatementBelow>.'
				checkCondition: [:editor | method statements size > 2 and: [method statements second isArrayBlock]]]
]

{ #category : #steps }
SBTutorialStep class >> stepMovement: anEditor [

	SBTutorialStep new
		title: 'Movement';
		addIntroText: 'Hey! First we''ll look at moving your cursor. You can click on things, but try to only use your keyboard to get used to it. <#selectPrevious>/<#selectNextGroup>/<#selectPreviousGroup>/<#selectNext> moves your cursor around.

Note that you always undo accidental changes with <#undo> (and redo with <#redo>) and you can reset the code sample with the refresh button on the center left. Once done, you can swap to the next chapter with the arrow button on the right.';
		addAction: #selectPrevious;
		addAction: #selectNextGroup;
		addAction: #selectPreviousGroup;
		addAction: #selectNext;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [ | y x |
					true & false not & nil isNil ifFalse: [52 squared].
					y := self size + super size.
					#($a #a 1 1.0) do: [:each |
						Transcript
							show: each class name;
							show: ' '].
					^ x < y]
				in: anEditor.
			step
				addStep: 'Select the empty string in the Transcript show cascade by moving the cursor with the keyboard'
				checkCondition: [:editor | editor selection = method body statements third arguments first statements first messages second arguments first].
			step
				addStep: 'Select the 52 in the ifFalse: block'
				checkCondition: [:editor | editor selection = method body statements first arguments first statements first receiver].
			step
				addStep: 'Select the character $a'
				checkCondition: [:editor | editor selection = method body statements third receiver submorphs first]]
]

{ #category : #methods }
SBTutorialStep class >> stepMovementMethod [ | y x |
true & false not & nil isNil
		ifFalse: [52 squared].
	y := self size + super size.
	#($a #a 1 1.0)
		do: [:each | Transcript show: each class name;
				 show: ' '].
	^ x < y
]

{ #category : #steps }
SBTutorialStep class >> stepMultiSelection: anEditor [

	SBTutorialStep new
		title: 'Multi Selection';
		addIntroText: 'You can multiselect elements with a dedicated selection mode. Many commands will then act on all elements at once.';
		addAction: #addElement;
		addAction: #wrapInDynamicArray;
		addAction: #unpackList;
		addAction: #addElement;
		addAction: #promptAction;
		setup: anEditor
			do: [:step | | method |
				method := step createStepMethod: [
					3 yourself.
					4 squared.
					5] in: anEditor.
				step
					addStep: 'Shift+click the `3 yourself`.'
					checkCondition: [:editor |
						editor mode = #selection and: [editor multiSelection first selector = 'yourself']].
				step
					addStep: 'Navigate to the `4 squared` and press <#startOrAddToMultiSelection> or Shift+click it again to add it to your multi selection.'
					checkCondition: [:editor | editor multiSelection last selector = 'squared'].
				step
					addStep: 'Also add the 5 to your selection.'
					checkCondition: [:editor | editor multiSelection last contents = '5'].
				step
					addStep: 'Press <#wrapInDynamicArray> to wrap your multi selection in an array.'
					checkCondition: [:editor | method statements first isArrayBlock].
				step
					addStep: 'Add a 6 to the array using <#addElement> or <#insertElementAfter>.'
					checkCondition: [:editor |
						method statements first submorphCount = 4 and: [
							method statements first lastSubmorph contents = '6']].
				step
					addStep: 'Finally, you can unpack the array again using the unpackList command, which might not be bound (<#unpackList>). If it is not bound, you can access it by selecting the array and pressing <#promptAction> or right clicking it to see all available commands and filter for unpack.'
					checkCondition: [:editor | method statements size = 4]]
]

{ #category : #steps }
SBTutorialStep class >> stepSelection: anEditor [

	SBTutorialStep new
		title: 'Selection';
		addIntroText: 'So far, we''ve only selected leaf nodes (i.e. nodes without children). Let''s try selecting larger groups.';
		addAction: #selectUp;
		addAction: #selectDown;
		addAction: #deleteBlock;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [ | y x |
					true & false not & nil isNil ifFalse: [52 squared].
					y := self size + super size.
					#($a #a 1 1.0) do: [:each |
						Transcript
							show: each class name;
							show: ' '].
					^ x < y]
				in: anEditor.
			step
				addStep: 'First, select the block argument ''each'' in the 2nd to last line.'
				checkCondition: [:editor | editor selection = method body statements third arguments first bindings first].
			step
				addStep: 'Then repeatedly use <#selectUp> to enlargen your selection to select the full do: message send. You can use <#selectDown> to go down again.'
				checkCondition: [:editor | editor selection = method body statements third].
			step
				addStep: 'Finally, as an example use <#deleteBlock> to delete the full block.'
				checkCondition: [:editor | method body statements noneSatisfy: [:s | s selector = 'do:']]]
]

{ #category : #steps }
SBTutorialStep class >> stepSmalltalkThings: anEditor [

	SBTutorialStep new
		title: 'Smalltalk Things';
		addAction: #wrapInDynamicArray;
		addAction: #wrapInBlock;
		addAction: #wrapInReturn;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					5 = 2 ifTrue: (Transcript showln: 'true') ifFalse: [123].
					65 do: [:each | each].
					Morph new]
				in: anEditor.
			step
				addStep: 'Wrap the argument to the ifTrue: in a block by selecting the whole message send via <#selectUp>, then press <#wrapInBlock>.'
				checkCondition: [:editor | method statements first arguments first isBlockBody].
			step
				addStep: 'Next, wrap the 65 in an array by pressing <#wrapInDynamicArray>. Note that the yellow outline indicates that #do: is not understood by 65.'
				checkCondition: [:editor | method statements second receiver isArrayBlock].
			step
				addStep: 'Finally, wrap the last statement in a return by pressing <#wrapInReturn>.'
				checkCondition: [:editor | method statements last isReturn]]
]

{ #category : #steps }
SBTutorialStep class >> stepSwapping: anEditor [

	SBTutorialStep new
		title: 'Swapping';
		addIntroText: 'In a text editor, you usually move code by copy-pasting. Here, you can also use swap commands directly.';
		addAction: #swapLeft;
		addAction: #swapRight;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					{3. 6. 4. 5}.
					self assert: (10 raisedTo: 2) = 1024]
				in: anEditor.
			step
				addStep: 'Select the 6 in the array'
				checkCondition: [:editor | editor selection contents = '6'].
			step
				addStep: 'Using <#swapRight>, move it to the end of the array.'
				checkCondition: [:editor | method body statements first lastSubmorph contents = '6'].
			step
				addStep: 'Select the 2 in the message send below the array.'
				checkCondition: [:editor | editor selection contents = '2' and: [editor selection containingStatement = method body statements second]].
			step
				addStep: 'Using <#swapLeft>, swap it with the number 10.'
				checkCondition: [:editor | method body statements second arguments first receiver receiver contents = '2']]
]

{ #category : #progress }
SBTutorialStep class >> tutorialSteps [

	^ {
		#stepMovement:.
		#stepDeleting:.
		#stepSelection:.
		#stepSwapping:.
		#stepBasicMessageSend:.
		SBEditor newInputMapping defaultState = #input ifTrue: [nil] ifFalse: [#stepInputMode:].
		#stepSmalltalkThings:.
		#stepAssignments:.
		#stepLists:.
		#stepMultiSelection:.
		#stepCascade:
	} select: #notNil
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addAction: anActionSymbol [

	shortcutsList addMorphBack: (SBButton new
		label: anActionSymbol
		shortcut: (SBEditor anyShortcutForAction: anActionSymbol)
		do: [self selectionDo: anActionSymbol])
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addAction: anActionSymbol if: aBoolean [

	aBoolean ifFalse: [^ self].
	shortcutsList addMorphBack: (SBButton new
		label: anActionSymbol
		shortcut: (SBEditor anyShortcutForAction: anActionSymbol)
		do: [self selectionDo: anActionSymbol])
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> addIntroText: aString [

	self
		addMorph: (SBMultilineOwnTextMorph new
			contents: aString withSBShortcuts;
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
			contents: aString withSBShortcuts;
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
				"error signal."
				false]) ifTrue: [
				checkbox value: true.
				self class markStepCompleted: selector index: index]]]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> childSandblocksDo: aBlock [

	self lastSubmorph isMethod ifTrue: [
		aBlock value: self lastSubmorph]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> createStepMethod: aBlock in: anEditor [

	| selector method |
	selector := thisContext sender method homeMethod selector allButLast, 'Method'.
	self class class
		compile: selector, ' ', aBlock sourceString allButFirst allButLast
		classified: 'methods'.
	method := (self class class >> selector asSymbol) asSandblock category: '*user-methods'.
	SBToggledCode comment: '' active: 2 do: {
		[^ anEditor open: self class class >> selector asSymbol].
		[
			self addMorphBack: (method hResizing: #spaceFill).
			^ method]}
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
		attachDecorator: SBResizableDecorator new;
		changeTableLayout;
		layoutInset: 8;
		cellGap: 16;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap;
		addMorphBack: (SBRow new addMorphBack: (title := SBStringMorph new large bold));
		addMorphBack: (shortcutsList := SBRow new cellGap: 8);
		addMorphBack: (steps := SBColumn new
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
	SBTutorialStep perform: nextSelector with: self sandblockEditor.
	self delete
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
	SBTutorialStep perform: previousSelector with: self sandblockEditor.
	self delete
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset [

	self class resetProgressFor: selector.
	self reset: self sandblockEditor
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset: anEditor [

	self lastSubmorph isMethod ifTrue: [self lastSubmorph delete].
	steps removeAllMorphs.
	anEditor openMorphInView: self.
	setup value: self.
	self extent: 0 @ 0.
	anEditor when: #selectionChanged send: #checkConditions to: self
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> selectionDo: aSymbol [

	self sandblockEditor selection performAction: aSymbol
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> setup: anEditor do: aBlock [

	selector := thisContext sender method homeMethod selector.
	setup := aBlock.
	
	self reset: anEditor.
	title contents: ('({1}/{2}) {3}' format: {self stepIndex. self class tutorialSteps size. title contents}).
	
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
