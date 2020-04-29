selection
updateSelectionLabel

	selectionLabel contents: (mode = #selection
		ifTrue: [multiSelection size asString, (' element' asPluralBasedOn: multiSelection)]
		ifFalse: [
			(self selection notNil and: [self selection isInWorld])
				ifTrue: [ | class |
					class := self selection guessClassExpensive.
					(self selection containingArtefact isNil or: [class isNil])
						ifTrue: [self selection printString]
						ifFalse:  ['{1} ({2})' format: {self selection printString. class asString}]]
				ifFalse: ['']])