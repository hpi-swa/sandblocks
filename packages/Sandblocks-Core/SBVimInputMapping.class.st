Class {
	#name : #SBVimInputMapping,
	#superclass : #SBInputMapping,
	#instVars : [
		'countModifier'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBVimInputMapping >> countModifier [

	^ countModifier ifEmpty: [0] ifNotEmpty: [countModifier asNumber]
]

{ #category : #accessing }
SBVimInputMapping >> defaultState [

	^ #command
]

{ #category : #'event handling' }
SBVimInputMapping >> handledEvent: anEvent in: anEditor [

	countModifier := ''
]

{ #category : #'initialize-release' }
SBVimInputMapping >> initialize [

	super initialize.
	
	countModifier := ''
]

{ #category : #'shortcut execute' }
SBVimInputMapping >> registerDefaultShortcuts [

	super registerDefaultShortcuts.

	self
		" navigation "
		cmdShortcut: $h do: #selectPrevious;
		cmdShortcut: $l do: #selectNext;
		cmdShortcut: $J do: #selectDown;
		cmdShortcut: $K do: #selectUp;
		cmdShortcut: $G do: #selectLast;
		cmdShortcut: $g do: #selectArtefact;
		cmdShortcut: $$ do: #selectRightMostBlock;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		cmdShortcut: $z do: #toggleCollapsed;
		cmdShortcut: $m do: #placeMark;
		cmdShortcut: $' do: #goToMark;
		cmdShortcut: $h command do: #selectLeftToplevel;
		cmdShortcut: $j command do: #selectBottomToplevel;
		cmdShortcut: $k command do: #selectTopToplevel;
		cmdShortcut: $l command do: #selectRightToplevel;
		cmdShortcut: $k do: #selectPreviousGroup;
		cmdShortcut: $j do: #selectNextGroup;
		cmdShortcut: $! do: #ensureVisible;
		cmdShortcut: $0 do: #selectStartOfStatement;
		
		" modify general "
		cmdShortcut: $, do: #promptAction;
		cmdShortcut: $i do: #startInputAtStart;
		cmdShortcut: $a do: #startInputAtEnd;
		cmdShortcut: $s do: #startInputSubstituting;
		cmdShortcut: $c do: #changeToUnknown;
		cmdShortcut: $Y do: #copyAround;
		cmdShortcut: $y do: #copyToBuffer;
		cmdShortcut: $X do: #deleteAround;
		cmdShortcut: $x do: #deleteBlock;
		cmdShortcut: $d do: #deleteAdjacent;
		cmdShortcut: $( do: #leftRotate;
		cmdShortcut: $. do: #appendElement;
		cmdShortcut: $+ do: #insertElementAfter;
		cmdShortcut: $* do: #insertElementBefore;
		cmdShortcut: $H do: #swapLeft;
		cmdShortcut: $L do: #swapRight;
		registerShortcut: $c command do: #copyString;
		registerShortcut: $v command do: #pasteString;
		cmdShortcut: $p do: #pasteAfter;
		cmdShortcut: $P do: #pasteBefore;
		shortcut: $v modes: #(command selection) do: #startOrAddToMultiSelection;
		cmdShortcut: $V do: #multiSelectChildren;
		cmdShortcut: $r do: #pasteReplace;

		" input "
		inputShortcut: Character escape do: #endInput;
		inputShortcut: Character tab do: #useSuggestion;
		inputShortcut: $j command do: #focusNextSuggestion;
		inputShortcut: $k command do: #focusPreviousSuggestion;
		inputShortcut: Character arrowLeft do: #moveTextCursorLeft;
		inputShortcut: $h command do: #moveTextCursorLeft;
		inputShortcut: Character arrowRight do: #moveTextCursorRight;
		inputShortcut: $l command do: #moveTextCursorRight;
		inputShortcut: $a command do: #moveCursorToStart;
		inputShortcut: $e command do: #moveCursorToEnd;
		inputShortcut: $x command do: #clearInput;
		registerShortcut: $1 command do: #useFirstArgument;
		registerShortcut: $2 command do: #useSecondArgument;
		registerShortcut: $3 command do: #useThirdArgument;
		registerShortcut: $4 command do: #useFourthArgument;
		registerShortcut: $5 command do: #useFifthArgument;
		inputShortcut: $' command do: #splitStringAtCursor;
		inputShortcut: Character backspace do: #deleteBeforeCursor;
		inputShortcut: Character delete do: #deleteAfterCursor;
		
		" refactor "
		cmdShortcut: $T do: #extractMethod;
		cmdShortcut: $t do: #createEmptySmalltalkMethod;
		cmdShortcut: $= do: #extractVariable;
		
		" debugging "
		cmdShortcut: $> shift do: #stepOver;
		cmdShortcut: $< do: #stepInto;
		cmdShortcut: $y command do: #stepThrough;
		cmdShortcut: $Y command do: #restartFrame;
		cmdShortcut: $e do: #focusErrors;
		cmdShortcut: $E do: #focusPreviousErrorFrame;
		
		" tools "
		cmdShortcut: $W do: #wrapWithWatch;
		cmdShortcut: $w do: #wrapWithExampleWatch;
		registerShortcut: $p command do: #evaluateExpression;
		registerShortcut: $d command do: #doExpression;
		registerShortcut: $P command do: #debugExpression;
		registerShortcut: $a command do: #addExample;
		registerShortcut: $m command do: #browseImplementors;
		registerShortcut: $n command do: #browseSenders;
		cmdShortcut: $x command do: #openOpenWindow;
		registerShortcut: $b command do: #browse;
		cmdShortcut: $q do: #convertTo;
		
		" editor "
		cmdShortcut: $u do: #undo;
		cmdShortcut: $U do: #redo;
		registerShortcut: $s command do: #save;
		registerShortcut: $r command do: #openRepl;
		registerShortcut: $, command do: #promptGlobalAction;
		cmdShortcut: $/ do: #startSearch;
		cmdShortcut: $n do: #nextSearchResult;
		registerShortcut: $f command do: #toggleFullscreen;

		shortcut: Character escape modes: #(selection) do: #endMultiSelection;
		cmdShortcut: Character escape do: #dismiss;

		registerShortcut: Character cr shift do: #insertStatementAbove;
		registerShortcut: Character cr do: #insertStatementBelow;

		" smalltalk "
		cmdShortcut: $" do: #wrapInOptinalVariant;
		cmdShortcut: $Q do: #wrapInVariant;
		cmdShortcut: $D do: #insertLabelAbove;
		cmdShortcut: $b do: #insertHaltBelow;
		cmdShortcut: $B do: #insertHaltAbove;
		cmdShortcut: $O do: #insertStatementAbove;
		cmdShortcut: $o do: #insertStatementBelow;
		registerShortcut: $[ do: #wrapInBlock;
		registerShortcut: ${ do: #wrapInDynamicArray;
		cmdShortcut: $# do: #wrapInLiteralArray;
		cmdShortcut: $: do: #wrapInAssignment;
		cmdShortcut: $; do: #wrapInCascade;
		registerShortcut: $^ do: #wrapInReturn;
		shortcut: Character space shift modes: #(input command) do: #wrapAsArgument;
		shortcut: Character space modes: #(input command) do: #wrapInMessageSend;
		
		" scheme "
		cmdShortcut: $( do: #wrapInSExpr;

		" javascript "
		cmdShortcut: ${ do: #wrapInObjectLiteral;
		cmdShortcut: Character space do: #wrapInInfixOp;
		cmdShortcut: Character space shift do: #wrapInPrefixOp

]

{ #category : #'event handling' }
SBVimInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEvent keyCharacter isDigit ifTrue: [
		countModifier := countModifier, anEvent keyCharacter.
		^ aBlock value]
]
