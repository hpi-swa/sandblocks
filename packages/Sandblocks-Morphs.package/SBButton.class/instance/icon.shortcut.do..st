as yet unclassified
icon: anIconMorph shortcut: aShortcut do: aBlock

	SBExample self: [SBButton new] args: [{SBIcon iconUndo. $u asSandblockShortcut. [nil]}] label: 'icon'.
	self widget: (anIconMorph
		color: Color black;
		yourself) shortcut: aShortcut do: aBlock