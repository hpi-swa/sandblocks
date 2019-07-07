shortcuts
addSingleSelectionShortcut: aShortcut do: anActionBlock

	singleSelectionShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}