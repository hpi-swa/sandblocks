as yet unclassified
cursorIndexForPosition: aPoint

	| font offset index |
	font := self fontToUse.
	offset := aPoint x - self position x.
	index := 0.
	[offset > 0 and: [index < self contents size]] whileTrue: [
		index := index + 1.
		offset := offset - (font widthOf: (self contents at: index))].
	^ offset > 0 ifTrue: [index + 1] ifFalse: [index]