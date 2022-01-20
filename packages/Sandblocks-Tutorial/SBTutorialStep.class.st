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

{ #category : #helper }
SBTutorialStep class >> copyClass: aClass in: anEditor [

	| newClass |
	newClass := Compiler evaluate: ((aClass definition
		copyReplaceAll: aClass name
		with: (aClass name copyFrom: 3 to: aClass name size - 'Example' size), DateAndTime now asUnixTime)
		copyReplaceAll: aClass category
		with: 'UserObjects').
	newClass copyAllCategoriesFrom: aClass.
	SBToggledCode comment: '' active: 1 do: {
		[newClass methodsDo: [:m | anEditor open: m]].
		[
			anEditor open: (SBStClassMethodEditor new
				class: newClass;
				expandAll)]}
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
		addAction: #appendElement;
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
				addStep: 'Wrap the expression `42 squared` in an assignment by selecting the expression (use <#moveCursorLarger>) and press <#wrapInAssignment>. Then type `largeNum` as name.'
				checkCondition: [:editor | method statements first isAssignment].
			step
				addStep: 'Hit save (<#save>) and declare the variable as method temporary. Note that there is no other way to declare temporary variables currently (i.e., place them in the pipes)'
				checkCondition: [:editor | method body temporaries notEmpty].
			step
				addStep: 'Next, create a new statement by pressing <#insertStatementBelow>. Type the name `var` and press <:> again while still in input mode. Assign 5 to this variable.'
				checkCondition: [:editor | method statements anySatisfy: [:s | s isAssignment and: [s binding contents = 'var']]].
			step
				addStep: 'The last way to create an assignment is to extract an expression. Select the 7>8, press <#extractVariable>, and name the new variable `comp`.'
				checkCondition: [:editor | method statements anySatisfy: [:s | s isMessageSend and: [s receiver in: [:r | r isName and: [r contents = 'comp']]]]]]
]

{ #category : #steps }
SBTutorialStep class >> stepBasicMessageSend: anEditor [

	SBTutorialStep new
		title: 'Basic Message Send';
		addIntroText: 'Let''s see how we can send messages to objects. Note that the autocompletion popup uses <#focusNextSuggestion> and <#focusPreviousSuggestion> to move in the suggestions list and <#useSuggestion> to accept a suggestion.';
		addAction: #wrapInMessageSend;
		addAction: #endInput if: anEditor inputIsDefault not;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					self assert: 1024 = 2.
					Transcript showln: 'yep!']
				in: anEditor.
			step addStep: 'Select the 2.' checkCondition: [:editor | editor selection contents = '2'].
			step
				addStep: 'Press <#wrapInMessageSend> to send a message to your selection, then type `rais` and select `raisedTo:` from the autocompletion popup.'
				checkCondition: [:editor | method statements first arguments first arguments first selector = 'raisedTo:'].
			step
				addStep: 'Type 10 in the now empty field for the argument', (anEditor inputIsDefault
					ifTrue: ['.']
					ifFalse: [' and press escpae to exit the input mode.'])
				checkCondition: [:editor | method statements first arguments first arguments first arguments first contents = '10'].
			step
				addStep: 'You can also use a block as the argument of a message using <#wrapAsArgument>. Select the full `Transcript showln:` expression, press <#wrapAsArgument> and type `true`.'
				checkCondition: [:editor | method statements last isMessageSend and: [method statements last selector = ':']].
			step
				addStep: 'Finally, use <#inputNextUnknown> to jump to the hole for the message name. We want to send `ifTrue:ifFalse:`, to do so type `ifTri` to find the right element in the autocompletion, then use <#useSuggestion> to accept it.'
				checkCondition: [:editor | method statements last selector = 'ifTrue:ifFalse:']]
]

{ #category : #steps }
SBTutorialStep class >> stepCascade: anEditor [

	SBTutorialStep new
		title: 'Cascades';
		addIntroText: 'Let''s format this morph construction code in a cascade. Remember you can press <#undo> to undo when anything goes wrong (and <#redo> to redo).';
		addAction: #wrapInCascade;
		addAction: #deleteAround;
		addAction: #pasteReplace;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [ | m |
					m := Morph new.
					m changeTableLayout.
					m hResizing: #shrinkWrap.
					m vResizing: #shrinkWrap]
				in: anEditor.
			step
				addStep: 'First, multiselect the changeTableLayout, hResizing:, and vResizing: message sends.'
				checkCondition: [:editor | editor mode = #selection and: [editor multiSelection size = 3 and: [editor multiSelection allSatisfy: [:m | m isMessageSend or: [m isMessagePart]]]]].
			step
				addStep: 'Create a cascade from your multiselection by pressing <#wrapInCascade>'
				checkCondition: [:editor | method statements second isCascade].
			step
				addStep: 'Let''s also move the cascade around our `Morph new` expression. Select the receiver of the cascade, the last `m`, and press <#deleteAround>, which deletes the element around your selection. The surrounding element is placed in your copy buffer with a hole where the `m` used to be.'
				checkCondition: [:editor | method statements second in: [:m | m isBinding and: [m contents = 'm']]].
			step
				addStep: 'Finally, select the full `Morph new` block and press <#pasteReplace> to paste the just copied surronding element around our selection. It will fit where the hole (the `m`) used to be.'
				checkCondition: [:editor | method statements first expression isCascade]]
]

{ #category : #steps }
SBTutorialStep class >> stepDeleting: anEditor [

	SBTutorialStep new
		title: 'Deleting';
		addIntroText: 'Let''s look at deleting in more detail.';
		addAction: #deleteBlockWithCopy;
		addAction: #deleteBlock;
		addAction: #pasteReplace;
		setup: anEditor do: [:step | | method |
			method := step createStepMethod: [{1. 2. 6. 3. 4. 5}] in: anEditor.
			step
				addStep: 'Delete the 6 in the list by pressing <#deleteBlockWithCopy>. It will then be placed in your copy buffer (use <#deleteBlock> to not copy the deleted block).'
				checkCondition: [:editor | method body statements first submorphs noneSatisfy: [:el | el contents = '6']].
			step
				addStep: 'Your current copy buffer is shown in the bottom-right corner. To insert the 6 in the right place, move your cursor using <#moveCursorRight> and <#moveCursorLeft> until you reach the gap just after the 5. A popup will tell you what block the insertion will take place in. Then use <#pasteReplace> to insert the block.'
				checkCondition: [:editor | method body statements first lastSubmorph submorphBefore contents = '5' and: [method body statements first lastSubmorph contents = '6']].
			step
				addStep: 'Finally, select the entire array using <#moveCursorLarger> and replace it with the still copied 6 using <#pasteReplace> for paste-replace.'
				checkCondition: [:editor | method body statements first contents = '6']]
]

{ #category : #steps }
SBTutorialStep class >> stepFinal: anEditor [

	SBTutorialStep new
		title: 'Congratulations!';
		addIntroText: 'You finished the tutorial, well done! Press the button below to create a copy of an example class where you can freely experiment with the shortcuts or jump into any existing Smalltalk method using <#openOpenWindow> (then use <Cmd+f> to directly jump to a class).';
		addMorphBack: (SBButton new icon: SBIcon iconFlask label: 'Open Example Morph Class' do: [
			anEditor togglePalette.
			self copyClass: SBExampleMorph in: anEditor]);
		setup: anEditor do: [:editor | ]
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
		title: 'Sequences';
		addIntroText: 'Many elements act as sequences, for example arrays, statements in blocks, or even message sends.

By moving your cursor horizontally, you will pass by all the positions where elements can be inserted.';
		addAction: #insertElementAfter;
		addAction: #insertElementBefore;
		addAction: #insertStatementAbove;
		addAction: #insertStatementBelow;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					{3. 4. 5}.
					[].
					5 between: 2 + 2]
				in: anEditor.
			step
				addStep: 'Add a 1 at the start of the array by moving the cursor just before it. Sandblocks will display a popup telling you that you are at an insert position. Then just hit the 1 on your keyboard.'
				checkCondition: [:editor | method statements first firstSubmorph contents = '1'].
			step
				addStep: 'To insert an element after the 1, move the cursor out of the 1 and type 2.'
				checkCondition: [:editor | method statements first submorphs second contents = '2'].
			step
				addStep: 'For sequences of statements, there is a special type of insert. Create an empty statement above the array using <#insertStatementAbove>. This works from any block independent of its nesting.'
				checkCondition: [:editor | method statements size > 2 and: [method statements second isArrayBlock]].
			"step
				addStep: 'Create an empty statement below the array by first moving the cursor to any number in the array and pressing <#insertStatementBelow>.'
				checkCondition: [:editor | method statements size > 3 and: [method statements second isArrayBlock]]."
			step
				addStep: 'If you have an empty sequence, you insert an empty element by moving the cursor inside via <#moveCursorLeft> and <#moveCursorRight>. Move the insert cursor into the empty block near the end of the method and insert a `6 squared` statement into it.'
				checkCondition: [:editor | (method statements detect: #isBlockBody) statements size > 0].
			step
				addStep: 'Message sends also act like sequences: each message part with its argument is an element. Complete the expression in the last line by moving the insert cursor until the popup tells you that you are modifying the `between:` message send, then insert an element by typing `and: 6` to form a `between:and:` call.'
				checkCondition: [:editor | method statements last prettySourceString = '5 between: 2 + 2 and: 6']]
]

{ #category : #steps }
SBTutorialStep class >> stepListsShortcuts: anEditor [

	SBTutorialStep new
		title: 'Sequences';
		addIntroText: 'Many elements act as sequences, for example arrays, statements in blocks, or even message sends.

<#insertElementBefore> will always insert an **empty** element before the current selection, <#insertElementAfter> after the current, similar to <#pasteBefore> and <#pasteAfter> that insert the **copied** element before and after the selection.';
		addAction: #insertElementAfter;
		addAction: #insertElementBefore;
		addAction: #appendElement;
		addAction: #insertStatementAbove;
		addAction: #insertStatementBelow;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					{3. 4. 5}.
					[].
					5 between: 2 + 2]
				in: anEditor.
			step
				addStep: 'Add a 1 at the start of the array by selecting the 3 and press <#insertElementBefore> to insert an element before.'
				checkCondition: [:editor | method statements first firstSubmorph contents = '1'].
			step
				addStep: 'To insert an element after the 1, use <#insertElementAfter> and type 2.'
				checkCondition: [:editor | method statements first submorphs second contents = '2'].
			step
				addStep: 'While <#insertElementBefore> and <#insertElementAfter> will always be adjacent to the current selection, for sequences of statements, there is a special type of insert. Create an empty statement above the array using <#insertStatementAbove>. This works from any block independent of its nesting.'
				checkCondition: [:editor | method statements size > 2 and: [method statements second isArrayBlock]].
			"step
				addStep: 'Create an empty statement below the array by first moving the cursor to any number in the array and pressing <#insertStatementBelow>.'
				checkCondition: [:editor | method statements size > 3 and: [method statements second isArrayBlock]]."
			step
				addStep: 'If you have an empty sequence, you can append an empty element by pressing <#appendElement>. Select the empty block near the end of the method and insert a `6 squared` statement into it.'
				checkCondition: [:editor | (method statements detect: #isBlockBody) statements size > 0].
			step
				addStep: 'Message sends also act like sequences, each message part with its argument is an element. Complete the expression in the last line by selecting the full `+` message send, then insert an element after using <#insertElementAfter> and type `and: 6` to form a `between:and:` call.'
				checkCondition: [:editor | method statements last prettySourceString = '5 between: 2 + 2 and: 6']]
]

{ #category : #steps }
SBTutorialStep class >> stepMovement: anEditor [

	SBTutorialStep new
		title: 'Movement';
		addIntroText: 'Hey, welcome to the tutorial! First we''ll look at moving your cursor. You can click on things, but try to get used to using your keyboard. <#moveCursorLeft>/<#moveCursorUp>/<#moveCursorDown>/<#moveCursorUp> moves your cursor around.

Note that you always undo accidental changes with <#undo> (and redo with <#redo>) and you can reset the code sample with the refresh button on the center left. Once done, you can swap to the next chapter with the arrow button on the right.';
		addAction: #moveCursorLeft;
		addAction: #moveCursorRight;
		addAction: #moveCursorUp;
		addAction: #moveCursorDown;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [ | y |
					true & false not & nil isNil ifFalse: [52 squared].
					y := self size + super size.
					#($a #a 1 1.0) do: [:each |
						Transcript
							show: each class name;
							show: ' '].
					^ 433 < y]
				in: anEditor.
			step
				addStep: 'Select the empty string in the Transcript show cascade by moving the cursor with the keyboard'
				checkCondition: [:editor | editor selection = method body statements third arguments first statements first messages second arguments first].
			step
				addStep: 'Select the 52 in the ifFalse: block'
				checkCondition: [:editor | editor selection = method body statements first arguments first statements first receiver].
			step
				addStep: 'Select the number 433 at the bottom'
				checkCondition: [:editor | editor selection contents = '433']]
]

{ #category : #steps }
SBTutorialStep class >> stepMultiSelection: anEditor [

	SBTutorialStep new
		title: 'Multi Selection';
		addIntroText: 'You can multiselect elements with a dedicated selection mode. Many commands will then act on all elements at once.';
		addAction: #wrapInDynamicArray;
		addAction: #unwrapList;
		addAction: #promptAction;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					3 yourself.
					4 squared.
					5]
				in: anEditor.
			step
				addStep: 'Shift+click the `3 yourself` to start a multiselection. (You can deselect all using <#endMultiSelection>).'
				checkCondition: [:editor | editor mode = #selection and: [editor multiSelection first selector = 'yourself']].
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
				addStep: 'Add a 6 to the array by moving your cursor after the 5 and typing a 6.'
				checkCondition: [:editor | method statements first submorphCount = 4 and: [method statements first lastSubmorph contents = '6']].
			step
				addStep: 'Finally, you can unwrap the array again using the unwrapList command, which might not be bound (<#unwrapList>). If it is not bound, you can access it by selecting the array and pressing <#promptAction> or right clicking it to see all available commands and filter for unwrap.'
				checkCondition: [:editor | method statements size = 4]]
]

{ #category : #steps }
SBTutorialStep class >> stepRestructuring: anEditor [

	SBTutorialStep new
		title: 'Restructuring';
		addIntroText: 'In this last chapter, we will take a quick look at some more complex transformations. You already know all the required commands.';
		addAction: #insertElementAfter;
		addAction: #wrapInReturn;
		addAction: #deleteAround;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [ | number |
					number := 2.
					({1. 4. 9. 16} includes: number) ifTrue: [^ OrderedCollection with: number sqrt + 1]]
				in: anEditor.
			step
				addStep: 'First, let''s add an ifFalse: branch. We want to insert it in the message send''s sequence, so move your cursor just after the block in the `ifTrue:`.'
				checkCondition: [:editor | editor cursor mode = #insert and: [editor cursor cursorPosition container contents = 'ifTrue:' and: [editor cursor cursorPosition adjacent isBlockBody]]].
			step
				addStep: 'Type `iff`, use the autocompletion and then jump to the next hole using <#inputNextUnknown>.'
				checkCondition: [:editor | method statements last selector = 'ifTrue:ifFalse:'].
			step
				addStep: 'Usually, when you want to type an expression, you simply type it and the editor will restructure the tree for you.

Be mindful of the space character: it will always start a new message send. Further, you can never type round parentheses, these are inferred from the blocks'' structure. Square or curly braces, on the other hand symbolize your intent to open a block closure or array.

Try typing `[OrderedCollection with: number squared + 3`.'
				checkCondition: [:editor | method statements last arguments second prettySourceString = '[OrderedCollection with: number squared + 3]'].
			step
				addStep: 'Finally, we want to move the return ("^") from inside the ifTrue: to the outside. Select the expression inside the return.'
				checkCondition: [:editor | method statements last selector = 'ifTrue:ifFalse:' and: [method statements last arguments first statements first childSandblocks first isSelected]].
			step
				addStep: 'Press <#deleteAround>.'
				checkCondition: [:editor | method statements last arguments first statements first isReturn not].
			step
				addStep: 'Since our copy buffer now contains a hole, we can paste it around the target block. Select the entire ifTrue:ifFalse: block, press <#pasteReplace> and we''re done!'
				checkCondition: [:editor | method statements last isReturn]]
]

{ #category : #steps }
SBTutorialStep class >> stepSelection: anEditor [

	SBTutorialStep new
		title: 'Selection';
		addIntroText: 'So far, we''ve only selected leaf nodes (i.e. nodes without children). Let''s try selecting larger groups.';
		addAction: #moveCursorLarger;
		addAction: #moveCursorSmaller;
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
				addStep: 'First, select the block closure argument '':each''. Note that the type of your selection is displayed in the bottom-left corner.'
				checkCondition: [:editor | editor selection = method body statements third arguments first bindings first].
			step
				addStep: 'Then repeatedly use <#moveCursorLarger> to enlargen your selection to select the full `do:` message send. You can use <#moveCursorSmaller> to go down again.'
				checkCondition: [:editor | editor selection = method body statements third].
			step
				addStep: 'Finally, as an example use <#deleteBlock> to delete the full `do:` message send.'
				checkCondition: [:editor | method body statements noneSatisfy: [:s | s selector = 'do:']]]
]

{ #category : #steps }
SBTutorialStep class >> stepSmalltalkThings: anEditor [

	SBTutorialStep new
		title: 'Smalltalk Things';
		addIntroText: 'Some things are broken in this method and require us to wrap them with the correct language constructs.

Note the yellow outline that indicates that a receiver will likely not understand the message we''re sending. So let''s fix these!';
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
				addStep: 'Wrap the `Transcript showln: ''true` after the ifTrue: in a block by selecting the whole `Transcript showln:` message send via <#moveCursorLarger>, then press <#wrapInBlock>.'
				checkCondition: [:editor | method statements first arguments first isBlockBody].
			step
				addStep: 'Next, wrap the 65 in an array by pressing <#wrapInDynamicArray>.'
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
		addAction: #clearInput;
		setup: anEditor do: [:step | | method |
			method := step
				createStepMethod: [
					{3. 6. 4. 5}.
					self assert: (10 raisedTo: 2) = 77777]
				in: anEditor.
			step
				addStep: 'Select the 6 in the array'
				checkCondition: [:editor | editor selection contents = '6'].
			step
				addStep: 'Using <#swapRight>, swap the 6 until it reaches the end of the array.'
				checkCondition: [:editor | method body statements first lastSubmorph contents = '6'].
			step
				addStep: 'Select the 2 in the message send below the array.'
				checkCondition: [:editor | editor selection contents = '2' and: [editor selection containingStatement = method body statements second]].
			step
				addStep: 'Using <#swapLeft>, swap it with the number 10.'
				checkCondition: [:editor | method body statements second arguments first receiver receiver contents = '2'].
			step
				addStep: 'While we''re here, one more useful shortcut to know: move the cursor into the 77777, press <#clearInput> to empty it, then type 1024.'
				checkCondition: [:editor | method lastDeepChild contents = '1024']]
]

{ #category : #progress }
SBTutorialStep class >> tutorialSteps [

	^ {
		#stepMovement:.
		#stepSelection:.
		#stepDeleting:.
		#stepSwapping:.
		#stepBasicMessageSend:.
		SBEditor newInputMapping defaultState = #input
			ifTrue: [nil]
			ifFalse: [#stepInputMode:].
		#stepSmalltalkThings:.
		#stepAssignments:.
		#stepLists:.
		#stepMultiSelection:.
		#stepCascade:.
		#stepRestructuring:.
		#stepFinal:} select: #notNil
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
		cellPositioning: #topLeft;
		changeTableLayout;
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
			([(checkbox valueOfProperty: #checkBlock) value: self sandblockEditor]
				on: Error
				do: [:error | "error signal."
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

	| method selector |
	selector := thisContext sender method homeMethod selector allButLast, 'Method'.
	method := (self class respondsTo: selector asSymbol)
		ifTrue: [(self class class >> selector asSymbol) asSandblock]
		ifFalse: [
			self class class
				compile: selector, ' ', aBlock sourceString allButFirst allButLast
				classified: '*user-methods'.
			(self class class >> selector asSymbol) asSandblock category: '*user-methods'].
	SBToggledCode comment: '' active: 2 do: {
		[^ anEditor open: self class class >> selector asSymbol].
		[
			self addMorphBack: (method hResizing: #spaceFill).
			^ method]}
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> drawnColor [

	^ self colorPolicy toolColorFor: self
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> example [

	SBMorphExample
		setUp: [
			SBTutorialStep new
				title: '01 Movement';
				addIntroText: 'Here we get to know the basics to move around the system. The text is gonna be rather long so make sure we can wrap properly.';
				addAction: #moveCursorLeft;
				addAction: #moveCursorRight;
				addAction: #moveCursorLarger;
				addAction: #moveCursorSmaller;
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
		addMorphBack: (shortcutsList := SBRow new
			hResizing: #spaceFill;
			changeTableLayout;
			wrapDirection: #leftToRight;
			cellGap: 8);
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

	^ self
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
	self class class removeSelector: (selector allButLast, 'Method') asSymbol.
	self reset: self sandblockEditor
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> reset: anEditor [

	self lastSubmorph isMethod ifTrue: [self lastSubmorph delete].
	steps removeAllMorphs.
	self extent: 0 @ 0.
	setup value: self.
	anEditor openMorphInView: self.
	anEditor when: #selectionChanged send: #checkConditions to: self.
	self lastSubmorph isMethod ifTrue: [self sandblockEditor startInput: self lastSubmorph at: 1 replacingContents: false]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> resetAllProgress [
	<action>
	
	self class resetAllProgress
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
			icon: SBIcon iconArrowLeft shortcut: nil do: [self previous])].
	self stepIndex < self class tutorialSteps size ifTrue: [
		buttons addMorphBack: (SBButton new
			balloonText: 'Next Task';
			icon: SBIcon iconArrowRight shortcut: nil do: [self next])]
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> step [

	self checkConditions
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> stepIndex [

	^ self class tutorialSteps indexOf: selector
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> stepTime [

	^ 1000
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> title: aString [

	title contents: aString
]

{ #category : #'as yet unclassified' }
SBTutorialStep >> unregister [

	self sandblockEditor removeActionsWithReceiver: self
]
