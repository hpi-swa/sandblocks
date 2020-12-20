as yet unclassified
cursorPosition

	| font offset index |
	font := self fontToUse.
	offset := self position x.
	index := self cursor - 1.
	[index > 0] whileTrue: [
		index := index - 1.
		offset := offset + (font widthOf: (self contents at: index))].
	^ index @ self y