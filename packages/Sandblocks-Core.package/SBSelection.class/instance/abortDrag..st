as yet unclassified
abortDrag: anEvent

	self onAbortUndoIn ifNotNil: [:editor |
		editor undo.
		(editor morphsAt: anEvent position) do: [:m | m highlightForDrop: false]].
	self delete