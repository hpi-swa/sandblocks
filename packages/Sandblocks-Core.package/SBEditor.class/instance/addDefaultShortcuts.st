shortcuts
addDefaultShortcuts

	SBLabel text: ['Tree Modification'].
	self
		addSingleSelectionShortcut: $K do: #swapLeft;
		addSingleSelectionShortcut: $J do: #swapRight;
		addSingleSelectionShortcut: $( do: #leftRotate;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $, do: #promptCodeAction;
		addSingleSelectionShortcut: $X do: #deleteAroundSelection;
		addMultiSelectionShortcut: $x do: #deleteSelection;
		addMultiSelectionShortcut: $# do: #wrapInLiteralArray.
	SBLabel text: ['Insert mode'].
	self
		addSingleSelectionShortcut: $i do: #startInputAtStart;
		addSingleSelectionShortcut: $a do: #startInputAtEnd;
		addSingleSelectionShortcut: $s do: #startInputSubstituting;
		addSingleSelectionShortcut: $c do: #changeSelection;
		addSingleSelectionShortcut: $c command do: #copyString;
		addSingleSelectionShortcut: $v command do: #pasteString;
		addSingleSelectionShortcut: Character tab shift do: [:editor | editor inputPreviousUnknown];
		addSingleSelectionShortcut: Character tab do: [:editor | editor inputNextUnknown].
	SBLabel text: ['Create nodes'].
	self
		addSingleSelectionShortcut: $d do: #insertLabelBelow;
		addSingleSelectionShortcut: $D do: #insertLabelAbove;
		addSingleSelectionShortcut: $O do: #insertStatementAbove;
		addSingleSelectionShortcut: $p do: #pasteStatementBelow;
		addSingleSelectionShortcut: $P do: #pasteStatementAbove;
		addSingleSelectionShortcut: $: do: #wrapInAssignment;
		addSingleSelectionShortcut: $^ do: #wrapInReturn;
		addSingleSelectionShortcut: Character space shift do: #wrapAsArgument;
		addSingleSelectionShortcut: Character space do: #wrapInMessageSend;
		addSingleSelectionShortcut: $o do: #insertStatementBelow;
		addSingleSelectionShortcut: $. do: #addElement;
		addSingleSelectionShortcut: $+ do: #insertElementAfter;
		addSingleSelectionShortcut: $* do: #insertElementBefore;
		addMultiSelectionShortcut: $[ do: #wrapInBlock;
		addMultiSelectionShortcut: ${ do: #wrapInDynamicArray;
		addMultiSelectionShortcut: $; do: #wrapInCascade.
	SBLabel text: ['Navigation'].
	self
		addSingleSelectionShortcut: $$ do: #selectRightMostBlock;
		addSingleSelectionShortcut: $0 asSandblockShortcut, Character home do: #selectContainingArtefact;
		addSingleSelectionShortcut: $z do: #toggleCollapsed;
		addSingleSelectionShortcut: $m do: #placeMark;
		addSingleSelectionShortcut: $' do: #goToMark;
		addMultiSelectionShortcut: $l do: #selectNext;
		addMultiSelectionShortcut: $h do: #selectPrevious;
		addMultiSelectionShortcut: $k do: #selectUp;
		addMultiSelectionShortcut: $j do: #selectDown;
		addMultiSelectionShortcut: $h command do: [:editor | editor selectToplevelTowards: #left];
		addMultiSelectionShortcut: $j command do: [:editor | editor selectToplevelTowards: #bottom];
		addMultiSelectionShortcut: $k command do: [:editor | editor selectToplevelTowards: #top];
		addMultiSelectionShortcut: $l command do: [:editor | editor selectToplevelTowards: #right];
		addMultiSelectionShortcut: $H do: #selectPreviousStatement;
		addMultiSelectionShortcut: $L do: #selectNextStatement;
		addCommandShortcut: $1 do: #resetZoom;
		addCommandShortcut: $g do: #selectMethod;
		addCommandShortcut: $G do: #selectLast;
		addCommandShortcut: $! do: #refocus.
	SBLabel text: ['Refactoring'].
	self
		addSingleSelectionShortcut: $= do: #extractVariable;
		addMultiSelectionShortcut: $t do: #extractMethod.
	SBLabel text: ['Tools'].
	self
		addSingleSelectionShortcut: $W do: #watchSelection;
		addSingleSelectionShortcut: $w do: #watchSelectionForExample;
		addSingleSelectionShortcut: $m command do: #implementorsOfIt;
		addSingleSelectionShortcut: $b command do: #browseSelection;
		addSingleSelectionShortcut: $p command do: #evaluateSelection;
		addSingleSelectionShortcut: $P command do: #debugSelection;
		addSingleSelectionShortcut: $n command do: #sendersOfIt;
		addSingleSelectionShortcut: $? do: #showUsageInfo;
		addCommandShortcut: $r command do: #openRepl;
		addCommandShortcut: $x command do: #openOpenWindow;
		addMultiSelectionShortcut: $" do: #wrapInToggledCode;
		addCommandShortcut: $a command do: #addExample;
		addCommandShortcut: $, command do: #promptMenu;
		addCommandShortcut: $/ do: #startSearch;
		addCommandShortcut: $n do: #nextSearchResult;
		addCommandShortcut: $S command do: #saveWorkspace;
		addCommandShortcut: $O command do: #promptOpenWorkspace;
		addCommandShortcut: $f command do: #toggleFullscreen;
		addCommandShortcut: $T do: #createEmptyMethod.
	SBLabel text: ['Tools: Debugger'].
	self
		addCommandShortcut: $> do: #stepOver;
		addCommandShortcut: $< do: #stepInto;
		addCommandShortcut: $R command do: #restartFrame;
		addCommandShortcut: $e do: #focusErrors;
		addCommandShortcut: $E do: #focusPreviousErrorFrame.
	SBLabel text: ['Persistence/History'].
	self
		addCommandShortcut: $s command do: #save;
		addCommandShortcut: $u do: #undo;
		addCommandShortcut: $U do: #redo.
	self
		addMultiSelectionShortcut: Character escape do: #endMultiSelection;
		addMultiSelectionShortcut: $y do: #copySelection;
		addMultiSelectionShortcut: $v do: #startOrAddToMultiSelection;
		addCommandShortcut: Character escape command do: #close;
		addInputShortcut: Character escape do: #endInput;
		addInputShortcut: Character arrowLeft do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: Character arrowRight do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: Character backspace do: [:editor | editor textMorph deleteBeforeCursor];
		addInputShortcut: Character delete do: [:editor | editor textMorph deleteAfterCursor];
		addInputShortcut: $h command do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: $l command do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: $a command do: [:editor | editor textMorph moveCursorTo: 1];
		addInputShortcut: $e command do: [:editor | editor textMorph moveCursorTo: 900000000];
		addInputShortcut: $x command do: [:editor | editor textMorph clear];
		addInputShortcut: Character tab shift do: [:editor | editor inputPreviousUnknown];
		addInputShortcut: Character tab do: [:editor | editor inputNextUnknown];
		addInputShortcut: $j command, Character arrowDown
			do: [:editor | editor currentInput suggestionMenuDo: #next];
		addInputShortcut: $k command, Character arrowUp
			do: [:editor | editor currentInput suggestionMenuDo: #previous];
		addInputShortcut: Character cr asSandblockShortcut do: [:editor | editor currentInput useSuggestion];
		addInputShortcut: $1 command do: [:editor | editor endInputWith: self method arguments first contents];
		addInputShortcut: $2 command do: [:editor | editor endInputWith: self method arguments second contents];
		addInputShortcut: $3 command do: [:editor | editor endInputWith: self method arguments third contents];
		addInputShortcut: $4 command do: [:editor | editor endInputWith: self method arguments fourth contents];
		addInputShortcut: $5 command do: [:editor | editor endInputWith: self method arguments fifth contents]