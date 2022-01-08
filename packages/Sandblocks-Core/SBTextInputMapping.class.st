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
		inputShortcut: Character backspace do: #deleteBeforeCursor;
		inputShortcut: Character delete do: #deleteAfterCursor;
		registerShortcut: $a command do: #clearInput;
		registerShortcut: $1 command, $1 option do: #useFirstArgument;
		registerShortcut: $2 command, $2 option do: #useSecondArgument;
		registerShortcut: $3 command, $3 option do: #useThirdArgument;
		registerShortcut: $4 command, $4 option do: #useFourthArgument;
		registerShortcut: $5 command, $5 option do: #useFifthArgument;
		inputShortcut: $' command do: #splitStringAtCursor;
		registerShortcut: Character space command do: #insertElementAfter;
		registerShortcut: Character space shift withCommand do: #insertElementBefore;
		registerShortcut: $i command do: #appendElement;
		registerShortcut: $I shift withCommand do: #prependElement;
		inputShortcut: Character cr command do: #typeNewLine.
	
	" cursor "
	self
		shortcut: Character arrowDown do: #moveCursorDown;
		shortcut: Character arrowUp do: #moveCursorUp;
		shortcut: Character arrowLeft do: #moveCursorLeft;
		shortcut: Character arrowRight do: #moveCursorRight;
		shortcut: Character arrowUp shift do: #moveCursorLarger;
		shortcut: Character arrowDown shift do: #moveCursorSmaller;
		shortcut: Character arrowLeft command do: #moveCursorLeftWordwise;
		shortcut: Character arrowRight command do: #moveCursorRightWordwise.
	
	" refactor "
	self
		registerShortcut: $T command do: #extractMethod;
		registerShortcut: $t command do: #createNewEmptyModule;
		cmdShortcut: $= do: #extractVariable.
	
	" debugging "
	self
		registerShortcut: $> command do: #stepOver;
		registerShortcut: $< command do: #stepInto;
		registerShortcut: $y command do: #stepThrough;
		registerShortcut: $Y command do: #restartFrame.
	
	" tools "
	self
		registerShortcut: $W command do: #wrapWithWatch;
		registerShortcut: $p command do: #evaluateExpression;
		registerShortcut: $d command do: #doExpression;
		registerShortcut: $D command do: #debugExpression;
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
		registerShortcut: $S command do: #saveCopy;
		registerShortcut: $l command do: #reloadArtefact;
		registerShortcut: $; command do: #promptGlobalAction;
		registerShortcut: $f command do: #startSearch;
		registerShortcut: $g command do: #nextSearchResult;
		registerShortcut: $t command do: #promptAddArtifact;
		registerShortcut: $J command do: #activateForces.
	
	" navigation "
	self
		registerShortcut: Character pageDown do: #selectLast;
		registerShortcut: Character pageUp do: #selectArtefact;
		registerShortcut: Character home do: #selectStartOfStatement;
		registerShortcut: Character end do: #selectRightMostBlock;
		registerShortcut: Character tab do: #useSuggestion;
		registerShortcut: Character tab shift do: #inputPreviousUnknown;
		registerShortcut: Character tab do: #inputNextUnknown;
		registerShortcut: Character arrowLeft option do: #selectLeftToplevel;
		registerShortcut: Character arrowDown option do: #selectBottomToplevel;
		registerShortcut: Character arrowUp option do: #selectTopToplevel;
		registerShortcut: Character arrowRight option do: #selectRightToplevel;
		registerShortcut: Character end shift do: #selectAdjacentAfter;
		registerShortcut: Character home shift do: #selectAdjacentBefore;
		registerShortcut: $A command do: #selectAdjacent.
	
	" modify general "
	self
		registerShortcut: $, command do: #promptAction;
		registerShortcut: $C command do: #copyAround;
		registerShortcut: $c command do: #copyToBuffer;
		registerShortcut: $v command do: #pasteReplace;
		registerShortcut: $e command do: #pasteAfter;
		registerShortcut: $E shift withCommand do: #pasteBefore;
		registerShortcut: Character arrowLeft command withShift do: #swapLeft;
		registerShortcut: Character arrowRight command withShift do: #swapRight;
		registerShortcut: $c asSandblockShortcut withOption do: #copyString;
		registerShortcut: $V command do: #pasteString;
		registerShortcut: $x command do: #deleteBlockWithCopy;
		registerShortcut: $X command do: #deleteAround;
		cmdShortcut: Character backspace asSandblockShortcut, Character delete do: #deleteBlock;
		registerShortcut: Character backspace shift do: #deleteAround;
		registerShortcut: Character cr shift do: #insertStatementAbove;
		registerShortcut: Character cr do: #insertStatementBelow.
	
	" multi selection "
	self
		shortcut: Character space modes: #(#selection) do: #startOrAddToMultiSelection;
		registerShortcut: Character escape do: #endMultiSelection.
	";
		registerShortcut: Character arrowLeft command withShift do: #multiSelectLeft;
		registerShortcut: Character arrowRight command withShift do: #multiSelectRight"
	" special overrides "
	self
		registerShortcut: Character escape do: #dismiss;
		cmdShortcut: Character space do: #activate
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
