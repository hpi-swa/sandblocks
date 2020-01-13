selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			(selection notNil and: [selection isInWorld])
				ifTrue: [
					(selection containingArtefact isNil or: [selection guessedClass isNil])
						ifTrue: [selection printString]
						ifFalse:  ['{1} ({2})' format: {selection printString. (selection guessedClass) asString}]]
				ifFalse: ['']])