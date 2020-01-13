selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			selection
				ifNotNil: [:s |
					(s containingArtefact isNil or: [s guessedClass isNil])
						ifTrue: [s printString]
						ifFalse:  ['{1} ({2})' format: {s printString. (s guessedClass) asString}]]
				ifNil: ['']])