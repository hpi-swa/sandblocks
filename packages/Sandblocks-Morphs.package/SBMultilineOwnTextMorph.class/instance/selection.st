as yet unclassified
selection

	| cursors |
	self hasSelection ifFalse: [^ ''].
	cursors := self selectionBounds.
	^ self contents copyFrom: cursors first to: cursors second - 1