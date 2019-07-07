shortcuts
addGlobalShortcut: aShortcut do: anActionBlock

	globalShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}