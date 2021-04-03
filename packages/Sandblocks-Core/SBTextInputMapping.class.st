Class {
	#name : #SBTextInputMapping,
	#superclass : #SBInputMapping,
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBTextInputMapping >> defaultState [

	^ #input
]

{ #category : #'event handling' }
SBTextInputMapping >> handledEvent: anEvent in: anEditor [
]

{ #category : #'shortcut execute' }
SBTextInputMapping >> registerDefaultShortcuts [

	super registerDefaultShortcuts.
	
	" input "
	self
		inputShortcut: Character arrowDown do: #focusNextSuggestion;
		inputShortcut: Character arrowUp do: #focusPreviousSuggestion;
		inputShortcut: $j command do: #focusNextSuggestion;
		inputShortcut: $k command do: #focusPreviousSuggestion;
		inputShortcut: Character arrowLeft asSandblockShortcut, Character arrowLeft shift, Character arrowLeft command
			do: #moveCursorLeft;
		inputShortcut: Character arrowRight asSandblockShortcut, Character arrowRight shift, Character arrowRight command
			do: #moveCursorRight;
		inputShortcut: Character arrowUp asSandblockShortcut, Character arrowUp command do: #moveCursorUp;
		inputShortcut: Character arrowDown asSandblockShortcut, Character arrowDown command
			do: #moveCursorDown;
		inputShortcut: Character arrowUp do: #moveCursorUp;
		inputShortcut: Character backspace do: #deleteBeforeCursor;
		inputShortcut: Character delete do: #deleteAfterCursor;
		registerShortcut: $a command do: #clearInput;
		registerShortcut: $1 command do: #useFirstArgument;
		registerShortcut: $2 command do: #useSecondArgument;
		registerShortcut: $3 command do: #useThirdArgument;
		registerShortcut: $4 command do: #useFourthArgument;
		registerShortcut: $5 command do: #useFifthArgument;
		inputShortcut: $' command do: #splitStringAtCursor;
		registerShortcut: $+ command do: #insertElementAfter;
		registerShortcut: $* command do: #insertElementBefore;
		registerShortcut: $i command do: #appendElement;
		registerShortcut: $I shift withCommand do: #prependElement;
		inputShortcut: Character cr command do: #typeNewLine.
	
	" refactor "
	self
		registerShortcut: $T command do: #extractMethod;
		registerShortcut: $t command do: #createEmptySmalltalkMethod;
		cmdShortcut: $= do: #extractVariable.
	
	" debugging "
	self
		registerShortcut: $> command do: #stepOver;
		registerShortcut: $< command do: #stepInto;
		registerShortcut: $y command do: #stepThrough;
		registerShortcut: $Y command do: #restartFrame.
	"registerShortcut: $e command do: #focusErrors;
		registerShortcut: $E command do: #focusPreviousErrorFrame;"
	" tools "
	self
		registerShortcut: $W command do: #wrapWithWatch;
		registerShortcut: $w command do: #wrapWithExampleWatch;
		registerShortcut: $p command do: #evaluateExpression;
		registerShortcut: $d command do: #doExpression;
		registerShortcut: $P command do: #debugExpression;
		registerShortcut: $m command do: #browseImplementors;
		registerShortcut: $n command do: #browseSenders;
		registerShortcut: $o command do: #openOpenWindow;
		registerShortcut: $b command do: #browse.
	
	" editor "
	self
		registerShortcut: $z command do: #undo;
		registerShortcut: $Z command do: #redo;
		registerShortcut: $s command do: #save;
		registerShortcut: $; command do: #promptMenu;
		registerShortcut: $f command do: #startSearch;
		registerShortcut: $g command do: #nextSearchResult;
		registerShortcut: $f command do: #toggleFullscreen.
	"registerShortcut: $r command do: #openRepl;"
	
	" navigation "
	self
		cmdShortcut: Character arrowLeft asSandblockShortcut withCommand, Character arrowLeft
			do: #selectPrevious;
		cmdShortcut: Character arrowRight asSandblockShortcut withCommand, Character arrowRight
			do: #selectNext;
		registerShortcut: Character arrowDown shift do: #selectDown;
		registerShortcut: Character arrowUp shift do: #selectUp;
		registerShortcut: Character pageDown do: #selectLast;
		registerShortcut: Character pageUp do: #selectArtefact;
		registerShortcut: Character home do: #selectStartOfStatement;
		registerShortcut: Character end do: #selectRightMostBlock;
		registerShortcut: Character tab do: #useSuggestion;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		registerShortcut: Character arrowUp asSandblockShortcut, Character arrowUp command
			do: #selectPreviousGroup;
		registerShortcut: Character arrowDown asSandblockShortcut, Character arrowDown command
			do: #selectNextGroup;
		registerShortcut: Character arrowLeft asSandblockShortcut withOption withCtrl
			do: #selectLeftToplevel;
		registerShortcut: Character arrowDown asSandblockShortcut withOption withCtrl
			do: #selectBottomToplevel;
		registerShortcut: Character arrowUp asSandblockShortcut withOption withCtrl
			do: #selectTopToplevel;
		registerShortcut: Character arrowRight asSandblockShortcut withOption withCtrl
			do: #selectRightToplevel.
	
	" modify general "
	self
		registerShortcut: $, command do: #promptAction;
		registerShortcut: $C command do: #copyAround;
		registerShortcut: $c command do: #copyToBuffer;
		registerShortcut: $v command do: #pasteReplace;
		registerShortcut: $e command do: #pasteAfter;
		registerShortcut: $E shift withCommand do: #pasteBefore;
		cmdShortcut: $( do: #leftRotate;
		registerShortcut: Character arrowLeft command withShift do: #swapLeft;
		registerShortcut: Character arrowRight command withShift do: #swapRight;
		registerShortcut: $c asSandblockShortcut withOption do: #copyString;
		registerShortcut: $v asSandblockShortcut withOption do: #pasteString;
		registerShortcut: $x command do: #deleteBlock;
		registerShortcut: $X command do: #deleteAround;
		cmdShortcut: Character backspace asSandblockShortcut, Character delete do: #deleteBlock;
		registerShortcut: Character backspace shift do: #deleteAround;
		registerShortcut: Character cr shift do: #insertStatementAbove;
		registerShortcut: Character cr do: #insertStatementBelow.
	"registerShortcut: $c do: #changeToUnknown;"
	"registerShortcut: $d do: #deleteAdjacent;"
	"registerShortcut: $. do: #addElement;"
	
	" modify smalltalk "
	self
		cmdShortcut: $" do: #wrapInToggledCode;
		registerShortcut: $[ do: #wrapInBlock;
		registerShortcut: ${ do: #wrapInDynamicArray;
		cmdShortcut: $: do: #wrapInAssignment;
		cmdShortcut: $; do: #wrapInCascade;
		registerShortcut: $^ do: #wrapInReturn;
		cmdShortcut: $' do: #useAsStString;
		cmdShortcut: $# do: #useAsStSymbol;
		shortcut: Character space shift modes: #(#input #command) do: #wrapAsArgument;
		shortcut: Character space modes: #(#input #command) do: #wrapInMessageSend.
	"cmdShortcut: $D do: #insertLabelAbove;"
	
	" modify scheme "
	self
		registerShortcut: $( do: #wrapInSExpr;
		registerShortcut: $) do: #splitSExpr;
		cmdShortcut: $' do: #useAsScmSymbol;
		cmdShortcut: $" do: #useAsScmString.
	
	" javascript "
	self
		cmdShortcut: ${ do: #wrapInObjectLiteral;
		cmdShortcut: Character space do: #wrapInInfixOp;
		cmdShortcut: Character space shift do: #wrapInPrefixOp.
	
	" ohm "
	self
		cmdShortcut: $+ do: #wrapInPlus;
		cmdShortcut: $* do: #wrapInStar;
		cmdShortcut: $? do: #wrapInOptional;
		cmdShortcut: $| do: #wrapInAlternative.
	
	" multi selection "
	self
		shortcut: Character space modes: #(#selection) do: #startOrAddToMultiSelection;
		registerShortcut: Character escape do: #endMultiSelection.
	
	" special overrides "
	self
		registerShortcut: Character escape do: #dismiss;
		shortcut: Character space modes: #(#command) do: #startInputAtStart
]

{ #category : #'event handling' }
SBTextInputMapping >> unhandledEvent: anEvent in: anEditor didHandle: aBlock [

	anEditor selection ifNil: [^ self].

	((anEditor selection grammarHandler
		ifNotNil: [:h | h characterCanStartInput: anEvent keyCharacter]
		ifNil: [false]) and: [anEvent commandKeyPressed not and: [anEvent optionKeyPressed not and: [anEvent controlKeyPressed not]]]) ifTrue: [
			anEditor selection grammarHandler startOverrideInput: anEvent in: anEditor.
			aBlock value]
]
