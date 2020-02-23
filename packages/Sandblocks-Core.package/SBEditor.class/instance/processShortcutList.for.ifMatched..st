shortcuts
processShortcutList: aCollection for: anEvent ifMatched: aBlock

	aCollection do: [:def |
		(def first asOrderedCollection anySatisfy: [:shortcut | shortcut matchesEvent: anEvent]) ifTrue: [
			" allow handlers to explicitly opt out by returning false "
			(def second value: self) = false ifFalse: [^ aBlock value]]]