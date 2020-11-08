Class {
	#name : #SBTextInputMapping,
	#superclass : #SBInputMapping,
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTextInputMapping >> defaultState [

	^ #input
]

{ #category : #'as yet unclassified' }
SBTextInputMapping >> handledEvent: anEvent in: anEditor [
]

{ #category : #'as yet unclassified' }
SBTextInputMapping >> registerDefaultShortcuts [

	self
		" modify general "
		registerShortcut: $, do: #promptAction;
		"registerShortcut: $c do: #changeToUnknown;"
		registerShortcut: $C command do: #copyAround;
		registerShortcut: $c command do: #copyToBuffer;
		registerShortcut: $v command do: #pasteBelow;
		"registerShortcut: $d do: #deleteAdjacent;"
		"registerShortcut: $( do: #leftRotate;"
		"registerShortcut: $. do: #addElement;"
		registerShortcut: Character arrowLeft command withShift do: #swapLeft;
		registerShortcut: Character arrowRight command withShift do: #swapRight;
		"registerShortcut: $c command do: #copyString;
		registerShortcut: $v command do: #pasteString;"
		registerShortcut: $p do: #pasteBelow;
		registerShortcut: $P do: #pasteAbove;
		registerShortcut: $v do: #startOrAddToMultiSelection;
		registerShortcut: $V command do: #startContinuousMultiSelection;
		registerShortcut: $V do: #multiSelectChildren;
		registerShortcut: $r do: #replaceWithCopyBuffer;
		registerShortcut: Character backspace do: #deleteBlock;
		registerShortcut: Character delete do: #deleteAround;

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
		registerShortcut: Character cr do: #useSuggestion;
		registerShortcut: Character arrowLeft asSandblockShortcut, Character arrowLeft shift, Character arrowLeft command do: #moveCursorLeft;
		registerShortcut: Character arrowRight asSandblockShortcut, Character arrowRight shift, Character arrowRight command do: #moveCursorRight;
		registerShortcut: Character arrowUp asSandblockShortcut do: #moveCursorUp;
		registerShortcut: Character arrowDown do: #moveCursorDown;
		registerShortcut: Character arrowUp do: #moveCursorUp;
		registerShortcut: Character home do: #moveCursorToStart;
		registerShortcut: Character end do: #moveCursorToEnd;
		registerShortcut: Character backspace do: #deleteBeforeCursor;
		registerShortcut: Character delete do: #deleteAfterCursor;
		registerShortcut: $a command do: #clearInput;
		registerShortcut: $j command do: #focusNextSuggestion;
		registerShortcut: $k command do: #focusPreviousSuggestion;
		registerShortcut: $1 command do: #useFirstArgument;
		registerShortcut: $2 command do: #useSecondArgument;
		registerShortcut: $3 command do: #useThirdArgument;
		registerShortcut: $4 command do: #useFourthArgument;
		registerShortcut: $5 command do: #useFifthArgument;
		registerShortcut: $' command do: #splitStringAtCursor;
		registerShortcut: $+ command do: #insertElementAfter;
		registerShortcut: $* command do: #insertElementBefore;
		
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
		registerShortcut: $z command do: #undo;
		registerShortcut: $Z command do: #redo;
		registerShortcut: $s command do: #save;
		registerShortcut: $r command do: #openRepl;
		registerShortcut: $c command do: #openOpenWindow;
		registerShortcut: $, command do: #promptMenu;
		registerShortcut: $/ do: #startSearch;
		registerShortcut: $n do: #nextSearchResult;
		registerShortcut: $S command do: #saveWorkspace;
		registerShortcut: $O command do: #promptOpenWorkspace;
		registerShortcut: $f command do: #toggleFullscreen;
		
		" navigation "
		registerShortcut: Character arrowLeft asSandblockShortcut withCommand, Character arrowLeft do: #selectPrevious;
		registerShortcut: Character arrowRight asSandblockShortcut withCommand, Character arrowRight do: #selectNext;
		registerShortcut: Character arrowDown shift do: #selectDown;
		registerShortcut: Character arrowUp shift do: #selectUp;
		registerShortcut: Character pageDown do: #selectLast;
		registerShortcut: Character pageUp do: #selectArtefact;
		registerShortcut: Character home do: #selectStartOfStatement;
		registerShortcut: Character end do: #selectRightMostBlock;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		registerShortcut: Character arrowUp do: #selectPreviousGroup;
		registerShortcut: Character arrowDown do: #selectNextGroup
]

{ #category : #'as yet unclassified' }
SBTextInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEvent keyCharacter isAlphaNumeric ifTrue: [
		anEditor startInput: anEditor selection at: 0 replacingContents: true.
		anEditor selection keyStroke: anEvent.
		^ aBlock value]
]
