selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			selection
				ifNotNil: [:s |
					s containingMethod
						ifNil: [s printString]
						ifNotNil: ['{1} ({2})' format: {s printString. (s containingMethod typeFor: selection) asString}]]
				ifNil: ['']])