Class {
	#name : #SBVimInputMapping,
	#superclass : #SBInputMapping,
	#instVars : [
		'selectionDownHistory',
		'selection',
		'mode',
		'countModifier'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBVimInputMapping >> countModifier [

	^ countModifier ifEmpty: [0] ifNotEmpty: [countModifier asNumber]
]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> defaultState [

	^ #command
]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> handledEvent: anEvent in: anEditor [

	countModifier := ''
]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> initialize [

	super initialize.
	
	countModifier := ''
]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> registerDefaultShortcuts [

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
		cmdShortcut: $. do: #addElement;
		cmdShortcut: $+ do: #insertElementAfter;
		cmdShortcut: $* do: #insertElementBefore;
		cmdShortcut: $H do: #swapLeft;
		cmdShortcut: $L do: #swapRight;
		registerShortcut: $c command do: #copyString;
		registerShortcut: $v command do: #pasteString;
		cmdShortcut: $p do: #pasteBelow;
		cmdShortcut: $P do: #pasteAbove;
		shortcut: $v modes: #(command selection) do: #startOrAddToMultiSelection;
		cmdShortcut: $V command do: #startContinuousMultiSelection;
		cmdShortcut: $V do: #multiSelectChildren;
		cmdShortcut: $r do: #replaceWithCopyBuffer;

		" input "
		inputShortcut: Character escape do: #endInput;
		inputShortcut: Character tab do: #useSuggestion;
		inputShortcut: $j command do: #focusNextSuggestion;
		inputShortcut: $k command do: #focusPreviousSuggestion;
		inputShortcut: Character arrowLeft do: #moveCursorLeft;
		inputShortcut: $h command do: #moveCursorLeft;
		inputShortcut: Character arrowRight do: #moveCursorRight;
		inputShortcut: $l command do: #moveCursorRight;
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
		registerShortcut: $, command do: #promptMenu;
		cmdShortcut: $/ do: #startSearch;
		cmdShortcut: $n do: #nextSearchResult;
		registerShortcut: $f command do: #toggleFullscreen;

		shortcut: Character escape modes: #(selection) do: #endMultiSelection;
		cmdShortcut: Character escape do: #dismiss;

		" smalltalk "
		cmdShortcut: $" do: #wrapInToggledCode;
		cmdShortcut: $D do: #insertLabelAbove;
		cmdShortcut: $b do: #insertHaltBelow;
		cmdShortcut: $B do: #insertHaltAbove;
		cmdShortcut: $O do: #insertStatementAbove;
		cmdShortcut: $o do: #insertStatementBelow;
		cmdShortcut: $[ do: #wrapInBlock;
		cmdShortcut: ${ do: #wrapInDynamicArray;
		cmdShortcut: $# do: #wrapInLiteralArray;
		cmdShortcut: $: do: #wrapInAssignment;
		cmdShortcut: $; do: #wrapInCascade;
		cmdShortcut: $^ do: #wrapInReturn;
		cmdShortcut: Character space shift do: #wrapAsArgument;
		cmdShortcut: Character space do: #wrapInMessageSend;
		
		" scheme "
		cmdShortcut: $( do: #wrapInSExpr;

		" javascript "
		cmdShortcut: ${ do: #wrapInObjectLiteral;
		cmdShortcut: Character space do: #wrapInInfixOp;
		cmdShortcut: Character space shift do: #wrapInPrefixOp

]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> resetState [

	selectionDownHistory := OrderedCollection new.
	selection := nil.
	self mode: #command
]

{ #category : #'as yet unclassified' }
SBVimInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEvent keyCharacter isDigit ifTrue: [
		countModifier := countModifier, anEvent keyCharacter.
		^ aBlock value]
]
