shortcuts
processShortcutList: aCollection for: anEvent ifMatched: aBlock

	aCollection do: [:shortcut |
		(shortcut first matchesEvent: anEvent) ifTrue: [
			shortcut second value: self.
			^ aBlock value]]