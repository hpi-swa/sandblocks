initialize-release
shortcutStringForAction: anAction

	^ String streamContents: [:stream |
		stream nextPut: $(.
		(self shortcutsForAction: anAction) do: [:shortcut | (shortcut isCollection ifTrue: [shortcut first] ifFalse: [shortcut]) printDisplayOn: stream] separatedBy: [stream space].
		stream nextPut: $)]