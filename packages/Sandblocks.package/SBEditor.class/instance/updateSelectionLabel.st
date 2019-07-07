selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [selection ifNotNil: #printString ifNil: ['']])