Class {
	#name : #SBTutorialSnippets,
	#superclass : #Morph,
	#category : #'Sandblocks-Tutorial'
}

{ #category : #'as yet unclassified' }
SBTutorialSnippets class >> workspace [
	"self workspace"

"Clipboard clipboardText: (SBWorkspaceHistory default items detect: [:i | i name =  'tutorial'] ifFound: #workspaceString)"
	
	^ (SBEditor new
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t13Evaluating at: (3047@3032));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t11Cascades at: (2776@2655));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t10Assignments at: (2722@2394));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t07Smalltalk at: (2517@1655));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t08Lists at: (2685@1815));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t05BasicMessageSend at: (1937@1559));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t06EditingValues at: (2010@1835));
openMorph: (SBRepl newFromSource: '[
	''Hi there! Welcome to the tutorial.
Use Cmd+hjkl to jump between steps/methods.

To ensure your selection is visible, press !

You can move the viewport either with horizontal scroll
or with the right mouse button.'']' named: 'Welcome to the tutorial!' at: (84@188));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t03Swapping at: (772@1277));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t02deleting at: (535@978));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t01movement at: (241@479));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t04Jumping at: (1224@1408));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t09MessageSends at: (2658@2023));
openMorph: (SBMethod newFor: SBTutorialSnippets >> #t12Projections at: (2791@2886));yourself) openInWindow
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t01movement [

	| y |
	SBLabel text: [
		'Move your selection by clicking or using hjkl.
To select larger parts, use shift+k and shift+j to make your selection smaller again.
 If anything breaks, use u to undo.

Try selecting the `12 squared` using only the keyboard.'].
	(true and: [false]) ifTrue: [5 squared].
	y := self size + super size.
	#($a #abc 'a' 1 1.0) do: [:each |
		Transcript showln: (each notNil ifTrue: [12 squared] ifFalse: [123])].
	^ 6 < y
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t02deleting [

	SBLabel text: [
		'Delete offending elements by selecting them and pressing x

After deleting an element, it will be copied. Press p to insert an element again.
Using P (capital p), you can insert the element before the cursor.

Bring the list into the right order using x and P.'].
	{1. 2. 6. 3. 4. 5}
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t03Swapping [

	SBLabel text: [
		'You can also move adjacent elements using H and L'].
	{1. 2. 6. 3. 4. 5}.
	SBLabel text: ['Try swapping the 2 and the 10'].
	10 raisedTo: 2
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t04Jumping [

	| y |
	SBLabel text: [
		'In a large method, you can navigate faster by using g and G to jump to the start or end.

Try selecting the `6 < y` at the end and pressing ma. This will place a marker on it.
With the marker in place, select the previous tutorial, then press ''a to jump back to the marker.
Pressing m on the marker again will delete it.'].
	(true and: [false]) ifTrue: [5 squared].
	y := self size + super size.
	#($a #abc 'a' 1 1.0) do: [:each |
		Transcript showln: (each notNil ifTrue: [12 squared] ifFalse: [123])].
	^ 6 < y
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t05BasicMessageSend [

	SBLabel text: [
		'To send a message to an expression, select it and press space.
Try sending raisedTo: to 2. To use an autocompletion, use Return.

Press escape when you''re done editing. Use cmd+s to save the method.'].
	self assert: 1024 = 2
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t06EditingValues [

	SBLabel text: [
		'To edit text, press i (at the start) or a (at the end) on a node.
Press s on the 3 to replace the contents and change it to a 10.

Remember to use u for undo and U for redo if anything goes wrong.'].
	self assert: 1024 = (2 raisedTo: 3)
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t07Smalltalk [

	SBLabel text: [
		'For smalltalk-specific constructs, use its letter to wrap an expression.

For example, press [ on the ifTrue: expression after selecting with ctrl+k.
Press ^ on the final expression of the method (use G to jump there).'].
	7 squared > 40 ifTrue: (Transcript showln: 'hello').
	42
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t08Lists [

	SBLabel text: [
		'Many elements have a variable number of children.
These include Arrays, Blocks and even keyword message sends.

Use . to append an element to a list, use + to insert an element after the selected
and * to insert an element before the selected.'].
	{32. 43. 12}.
	SBLabel text: [
		'Create your own arrays by pressing { on an element. Then press + to add more elements'].
	42
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t09MessageSends [

	SBLabel text: [
		'Change the call to a with:do: with a second array.

To do so, select the `do:` and press *. Type ''with'' and press tab. Type { to create a new array.
Finally, select the block argument :num and press + to add another binding and adapt the showln:'].
	{42. 12} do: [:num | Transcript showln: num].
	
	SBLabel text: ['This could be your final result:'].
	{42. 12} with: {54. 32} do: [:num :num2 | Transcript showln: {num. num2}].
	
	SBLabel text: [
		'One final note for statements: for convenience, o and O will insert statements in the current block.
This allows you to quickly create a new statement, even when you do not have a statement selected.

For example, select the 42 and press O.'].
	^ 42 squared
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t10Assignments [

	SBLabel text: [
		'There are three way to create assignments.
1) Select this comment and press o to create new statement.
Type a name and press : while still in input mode.
When you save the method, it will ask you to declare it.'].
	SBLabel text: ['2) Select the below expression and press :'].
	42 squared.
	SBLabel text: [
		'3) Select the boolean expression 7>8 and press =

Note that when you change the resulting variable name using s or i, both will update.'].
	7 > 8 ifTrue: [Transcript showln: 'Hi']
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t11Cascades [

	SBLabel text: [
		'To create cascades, multiselection comes in handy.
Select the first message, press v, navigate to the other messages and
also press v. Then press ;'].
	self changeTableLayout.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap.
	SBLabel text: [
		'To start a cascade, simply press ; on an existing message send. Then
use the usuall list operators to add more sends (+ * .)'].
	self color: 'red'
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t12Projections [

	SBLabel text: [
		'The editor will automatically replace expressions with matching projections.
Double click the color block to edit its value.

Try pressing , on the color block and choose representAs, then stExpression'].
	Color r: 0.548 g: 0.886 b: 0.07
]

{ #category : #'as yet unclassified' }
SBTutorialSnippets >> t13Evaluating [

	SBLabel text: [
		'You can evaluate expressions by pressing ctrl+p. Try with the below.'].
	Morph new.
	SBLabel text: [
		'Once evaluated, delete the result with x.
When you evaluate an expression, you will get different representations offered.

Evaluate the expression again and choose explorer.'].
	Morph new.
	SBLabel text: [
		'Once the explorer is opened, use z to show more details on an object.

You can always use , and representAs to choose a different representation.']
]
