shortcuts
addMultiSelectionShortcut: aShortcut do: anActionBlock

	multiSelectionShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}