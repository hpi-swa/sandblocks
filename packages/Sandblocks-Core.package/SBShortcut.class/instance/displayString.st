as yet unclassified
displayString

	SBExample self: [$p asSandblockShortcut] args: [{}] label: 'p'.
	SBExample self: [$p command] args: [{}] label: 'ctrl+p'.
	SBExample self: [$P command] args: [{}] label: 'ctrl+P'.
	^ String streamContents: [:stream | self printDisplayOn: stream]