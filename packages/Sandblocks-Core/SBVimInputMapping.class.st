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
		" auto completion "
		registerShortcut: $j command do: #focusNextSuggestion;
		registerShortcut: $k command do: #focusPreviousSuggestion;
		
		" navigation "
		registerShortcut: $h do: #selectPrevious;
		registerShortcut: $l do: #selectNext;
		registerShortcut: $J do: #selectDown;
		registerShortcut: $K do: #selectUp;
		registerShortcut: $G do: #selectLast;
		registerShortcut: $g do: #selectArtefact;
		registerShortcut: $$ do: #selectRightMostBlock;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		registerShortcut: $z do: #toggleCollapsed;
		registerShortcut: $m do: #placeMark;
		registerShortcut: $' do: #goToMark;
		registerShortcut: $h command do: #selectLeftToplevel;
		registerShortcut: $j command do: #selectBottomToplevel;
		registerShortcut: $k command do: #selectTopToplevel;
		registerShortcut: $l command do: #selectRightToplevel;
		registerShortcut: $k do: #selectPreviousGroup;
		registerShortcut: $j do: #selectNextGroup;
		registerShortcut: $! do: #ensureVisible;
		registerShortcut: $0 do: #selectStartOfStatement;
		
		" modify general "
		registerShortcut: $, do: #promptAction;
		registerShortcut: $i do: #startInputAtStart;
		registerShortcut: $a do: #startInputAtEnd;
		registerShortcut: $s do: #startInputSubstituting;
		registerShortcut: $c do: #changeToUnknown;
		registerShortcut: $Y do: #copyAround;
		registerShortcut: $y do: #copyToBuffer;
		registerShortcut: $X do: #deleteAround;
		registerShortcut: $x do: #deleteBlock;
		registerShortcut: $d do: #deleteAdjacent;
		registerShortcut: $( do: #leftRotate;
		registerShortcut: $. do: #addElement;
		registerShortcut: $+ do: #insertElementAfter;
		registerShortcut: $* do: #insertElementBefore;
		registerShortcut: $H do: #swapLeft;
		registerShortcut: $L do: #swapRight;
		registerShortcut: $c command do: #copyString;
		registerShortcut: $v command do: #pasteString;
		registerShortcut: $p do: #pasteBelow;
		registerShortcut: $P do: #pasteAbove;
		registerShortcut: $v do: #startOrAddToMultiSelection;
		registerShortcut: $V command do: #startContinuousMultiSelection;
		registerShortcut: $V do: #multiSelectChildren;
		registerShortcut: $r do: #replaceWithCopyBuffer;

		" modify smalltalk "
		registerShortcut: $" do: #wrapInToggledCode;
		registerShortcut: $D do: #insertLabelAbove;
		registerShortcut: $O do: #insertStatementAbove;
		registerShortcut: $o do: #insertStatementBelow;
		registerShortcut: $[ do: #wrapInBlock;
		registerShortcut: ${ do: #wrapInDynamicArray;
		registerShortcut: $# do: #wrapInLiteralArray;
		registerShortcut: $: do: #wrapInAssignment;
		registerShortcut: $; do: #wrapInCascade;
		registerShortcut: $^ do: #wrapInReturn;
		registerShortcut: Character space shift do: #wrapAsArgument;
		registerShortcut: Character space do: #wrapInMessageSend;
		
		" input "
		registerShortcut: Character escape do: #endInput;
		registerShortcut: Character cr do: #useSuggestion;
		registerShortcut: Character arrowLeft do: #moveCursorLeft;
		registerShortcut: $h command do: #moveCursorLeft;
		registerShortcut: Character arrowRight do: #moveCursorRight;
		registerShortcut: $l command do: #moveCursorRight;
		registerShortcut: $a command do: #moveCursorToStart;
		registerShortcut: $e command do: #moveCursorToEnd;
		registerShortcut: $x command do: #clearInput;
		registerShortcut: $1 command do: #useFirstArgument;
		registerShortcut: $2 command do: #useSecondArgument;
		registerShortcut: $3 command do: #useThirdArgument;
		registerShortcut: $4 command do: #useFourthArgument;
		registerShortcut: $5 command do: #useFifthArgument;
		registerShortcut: $' command do: #splitStringAtCursor;
		registerShortcut: Character backspace do: #deleteBeforeCursor;
		registerShortcut: Character delete do: #deleteAfterCursor;
		
		" refactor "
		registerShortcut: $T do: #extractMethod;
		registerShortcut: $t do: #createEmptyMethod;
		registerShortcut: $= do: #extractVariable;
		
		" debugging "
		registerShortcut: $> do: #stepOver;
		registerShortcut: $< do: #stepInto;
		registerShortcut: $y command do: #stepThrough;
		registerShortcut: $Y command do: #restartFrame;
		registerShortcut: $e do: #focusErrors;
		registerShortcut: $E do: #focusPreviousErrorFrame;
		
		" tools "
		registerShortcut: $W do: #wrapWithWatch;
		registerShortcut: $w do: #wrapWithExampleWatch;
		registerShortcut: $p command do: #evaluateExpression;
		registerShortcut: $d command do: #doExpression;
		registerShortcut: $P command do: #debugExpression;
		registerShortcut: $a command do: #addExample;
		registerShortcut: $m command do: #browseImplementors;
		registerShortcut: $n command do: #browseSenders;
		registerShortcut: $x command do: #openOpenWindow;
		registerShortcut: $b command do: #browse;
		
		" editor "
		registerShortcut: $u do: #undo;
		registerShortcut: $U do: #redo;
		registerShortcut: $s command do: #save;
		registerShortcut: $r command do: #openRepl;
		registerShortcut: $, command do: #promptMenu;
		registerShortcut: $/ do: #startSearch;
		registerShortcut: $n do: #nextSearchResult;
		registerShortcut: $S command do: #saveWorkspace;
		registerShortcut: $O command do: #promptOpenWorkspace;
		registerShortcut: $f command do: #toggleFullscreen;

		registerShortcut: Character escape do: #endMultiSelection;
		registerShortcut: Character escape do: #dismiss
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
