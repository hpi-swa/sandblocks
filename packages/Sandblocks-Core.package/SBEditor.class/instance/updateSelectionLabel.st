selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			(self selection notNil and: [self selection isInWorld])
				ifTrue: [
					(self selection containingArtefact isNil or: [self selection guessedClass isNil])
						ifTrue: [self selection printString]
						ifFalse:  ['{1} ({2})' format: {self selection printString. (self selection guessedClass) asString}]]
				ifFalse: ['']])