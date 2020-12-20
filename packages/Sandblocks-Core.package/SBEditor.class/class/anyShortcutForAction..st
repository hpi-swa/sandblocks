initialize-release
anyShortcutForAction: aSymbol

	^ (self shortcutsForAction: aSymbol) ifNotEmpty: #first ifEmpty: [nil]