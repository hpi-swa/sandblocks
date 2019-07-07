shortcuts
addDefaultShortcuts

	self
		addSingleSelectionShortcut: $H do: #swapLeft;
		addSingleSelectionShortcut: $L do: #swapRight;
		addSingleSelectionShortcut: $d do: #deleteAroundSelection;
		addSingleSelectionShortcut: $+ do: #addElement;
		addSingleSelectionShortcut: $i do: #startInputAtStart;
		addSingleSelectionShortcut: $a do: #startInputAtEnd;
		addSingleSelectionShortcut: $s do: #startInputSubstituting;
		addSingleSelectionShortcut: $o do: #insertStatementBelow;
		addSingleSelectionShortcut: $O do: #insertStatementAbove;
		addSingleSelectionShortcut: Character space shift do: #wrapAsArgument;
		addSingleSelectionShortcut: Character space do: #wrapInMessageSend;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $p do: #pasteStatementBelow;
		addSingleSelectionShortcut: $P do: #pasteStatementAbove;
		addSingleSelectionShortcut: $: do: #wrapInAssignment;
		addSingleSelectionShortcut: $^ do: #wrapInReturn;
		addSingleSelectionShortcut: $= do: #extractVariable;
		addSingleSelectionShortcut: $v command do: #pasteString;
		addSingleSelectionShortcut: $w do: #watchSelection;
		addSingleSelectionShortcut: $r do: #replaceWithCopyBuffer;
		addSingleSelectionShortcut: $c do: #changeSelection;
		
		addMultiSelectionShortcut: Character escape do: #endMultiSelection;
		addMultiSelectionShortcut: $l do: #selectNext;
		addMultiSelectionShortcut: $h do: #selectPrevious;
		addMultiSelectionShortcut: $k do: #selectUp;
		addMultiSelectionShortcut: $K do: #selectPreviousStatement;
		addMultiSelectionShortcut: $j do: #selectDown;
		addMultiSelectionShortcut: $J do: #selectNextStatement;
		addMultiSelectionShortcut: $x do: #deleteSelection;
		addMultiSelectionShortcut: $[ do: #wrapInBlock;
		addMultiSelectionShortcut: $y do: #copySelection;
		addMultiSelectionShortcut: ${ do: #wrapInDynamicArray;
		addMultiSelectionShortcut: $# do: #wrapInLiteralArray;
		addMultiSelectionShortcut: $v do: #startOrAddToMultiSelection;
		addMultiSelectionShortcut: $> do: #extractMethod;
		
		addCommandShortcut: $u do: #undo;
		addCommandShortcut: $U do: #redo;
		addCommandShortcut: $g do: #selectMethod;
		addCommandShortcut: $y command do: #promptChangeClass;
		addCommandShortcut: $l command do: #reset;
		addCommandShortcut: $s command do: #save;
		addCommandShortcut: $x command do: #promptSwitchMethodSameWindow;
		addCommandShortcut: $t command do: #promptSwitchMethodNewWindow;
		
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
		addInputShortcut: $j command do: [:editor | editor currentInput nextSuggestion];
		addInputShortcut: $k command do: [:editor | editor currentInput previousSuggestion];
		addInputShortcut: Character cr do: [:editor | editor currentInput useSuggestion]