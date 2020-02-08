shortcuts
addDefaultShortcuts

	self
		addSingleSelectionShortcut: $K do: #swapLeft;
		addSingleSelectionShortcut: $J do: #swapRight;
		addSingleSelectionShortcut: $d do: #deleteAroundSelection;
		addSingleSelectionShortcut: $i do: #startInputAtStart;
		addSingleSelectionShortcut: $$ do: #selectRightMostBlock;
		addSingleSelectionShortcut: $0 asSandblockShortcut, Character home do: #selectContainingArtefact;
		addSingleSelectionShortcut: $a do: #startInputAtEnd;
		addSingleSelectionShortcut: $s do: #startInputSubstituting;
		addSingleSelectionShortcut: $n do: #insertLabelBelow;
		addSingleSelectionShortcut: $N do: #insertLabelAbove;
		addSingleSelectionShortcut: $o do: #insertStatementBelow;
		addSingleSelectionShortcut: $O do: #insertStatementAbove;
		addSingleSelectionShortcut: $, do: #promptCodeAction;
		addSingleSelectionShortcut: Character space shift do: #wrapAsArgument;
		addSingleSelectionShortcut: Character space do: #wrapInMessageSend;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $p do: #pasteStatementBelow;
		addSingleSelectionShortcut: $P do: #pasteStatementAbove;
		addSingleSelectionShortcut: $: do: #wrapInAssignment;
		addSingleSelectionShortcut: $^ do: #wrapInReturn;
		addSingleSelectionShortcut: $= do: #extractVariable;
		addSingleSelectionShortcut: $c command do: #copyString;
		addSingleSelectionShortcut: $v command do: #pasteString;
		addSingleSelectionShortcut: $w do: #watchSelectionForExample;
		addSingleSelectionShortcut: $W do: #watchSelection;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $c do: #changeSelection;
		addSingleSelectionShortcut: $n command do: #sendersOfIt;
		addSingleSelectionShortcut: $m command do: #implementorsOfIt;
		addSingleSelectionShortcut: $b command do: #browseSelection;
		addSingleSelectionShortcut: $q do: #closeSelectedMethod;
		addSingleSelectionShortcut: $z do: #toggleMethodCollapsed;
		addSingleSelectionShortcut: $( do: #leftRotate;
		addSingleSelectionShortcut: $p command do: #evaluateSelection;
		addSingleSelectionShortcut: $m do: #placeMark;
		addSingleSelectionShortcut: $' do: #goToMark;
		addSingleSelectionShortcut: $+ do: #insertElementAfter;
		" FIXME: dependent on "
		addSingleSelectionShortcut: $* do: #insertElementBefore;
		
		addMultiSelectionShortcut: Character escape do: #endMultiSelection;
		addMultiSelectionShortcut: $l do: #selectNext;
		addMultiSelectionShortcut: $h do: #selectPrevious;
		addMultiSelectionShortcut: $k do: #selectUp;
		addMultiSelectionShortcut: $j do: #selectDown;
		addMultiSelectionShortcut: $H do: #selectPreviousStatement;
		addMultiSelectionShortcut: $L do: #selectNextStatement;
		addMultiSelectionShortcut: $x do: #deleteSelection;
		addMultiSelectionShortcut: $[ do: #wrapInBlock;
		addMultiSelectionShortcut: $y do: #copySelection;
		addMultiSelectionShortcut: ${ do: #wrapInDynamicArray;
		addMultiSelectionShortcut: $# do: #wrapInLiteralArray;
		addMultiSelectionShortcut: $v do: #startOrAddToMultiSelection;
		addMultiSelectionShortcut: $> do: #extractMethod;
		addMultiSelectionShortcut: $; do: #wrapInCascade;
		addMultiSelectionShortcut: $" do: #wrapInToggledCode;
		
		addCommandShortcut: $x command do: #openOpenWindow;
		addCommandShortcut: $1 do: #resetZoom;
		addCommandShortcut: $f command do: #toggleFullscreen;
		addCommandShortcut: $, command do: #promptMenu;
		addCommandShortcut: $a command do: #addExample;
		addCommandShortcut: $! do: #refocus;
		addCommandShortcut: $u do: #undo;
		addCommandShortcut: $U do: #redo;
		addCommandShortcut: $g do: #selectMethod;
		addCommandShortcut: $Y command do: #promptChangeClassNewWindow;
		addCommandShortcut: $y command do: #promptChangeClassSameWindow;
		addCommandShortcut: $s command do: #save;
		addCommandShortcut: $x command do: #promptSwitchMethodSameWindow;
		addCommandShortcut: $t command do: #promptSwitchMethodNewWindow;
		addCommandShortcut: $e do: #promptNewMethod;
		addCommandShortcut: Character escape command do: #close;
		addCommandShortcut: $S command do: #saveWorkspace;
		addCommandShortcut: $O command do: #promptOpenWorkspace;
		addCommandShortcut: $r command do: #openRepl;
		
		addInputShortcut: Character escape do: #endInput;
		addInputShortcut: Character arrowLeft do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: Character arrowRight do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: Character backspace do: [:editor | editor textMorph deleteBeforeCursor];
		addInputShortcut: Character delete do: [:editor | editor textMorph deleteAfterCursor];
		addInputShortcut: $h command do: [:editor | editor textMorph moveCursor: -1];
		addInputShortcut: $l command do: [:editor | editor textMorph moveCursor: 1];
		addInputShortcut: $a command do: [:editor | editor textMorph moveCursorTo: 1];
		addInputShortcut: $e command do: [:editor | editor textMorph moveCursorTo: 9e8];
		addInputShortcut: $x command do: [:editor | editor textMorph clear];
		addInputShortcut: $j command, Character arrowDown do: [:editor | editor currentInput suggestionMenuDo: #next];
		addInputShortcut: $k command, Character arrowUp do: [:editor | editor currentInput suggestionMenuDo: #previous];
		addInputShortcut: Character cr asSandblockShortcut", Character tab" do: [:editor | editor currentInput useSuggestion];
		addInputShortcut: $1 command do: [:editor | editor endInputWith: self method arguments first contents];
		addInputShortcut: $2 command do: [:editor | editor endInputWith: self method arguments second contents];
		addInputShortcut: $3 command do: [:editor | editor endInputWith: self method arguments third contents];
		addInputShortcut: $4 command do: [:editor | editor endInputWith: self method arguments fourth contents];
		addInputShortcut: $5 command do: [:editor | editor endInputWith: self method arguments fifth contents]