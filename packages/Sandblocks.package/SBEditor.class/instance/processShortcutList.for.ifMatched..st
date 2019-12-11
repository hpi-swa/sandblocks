shortcuts
processShortcutList: aCollection for: anEvent ifMatched: aBlock

	aCollection do: [:def |
		(def first asOrderedCollection anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]) ifTrue: [
			def second value: self.
			^ aBlock value]]