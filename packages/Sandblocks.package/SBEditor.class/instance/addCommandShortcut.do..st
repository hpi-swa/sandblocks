shortcuts
addCommandShortcut: aShortcut do: anActionBlock

	commandShortcuts add: {aShortcut asSandblockShortcut. anActionBlock}