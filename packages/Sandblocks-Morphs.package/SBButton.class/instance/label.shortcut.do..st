as yet unclassified
label: aString shortcut: aShortcut do: aBlock

	SBExample self: [SBButton new] args: [{'hello'. $p command. [nil]}] label: 'label'.
	self
		widget: (StringMorph new
			contents: aString;
			emphasis: TextEmphasis bold emphasisCode)
		shortcut: aShortcut
		do: aBlock