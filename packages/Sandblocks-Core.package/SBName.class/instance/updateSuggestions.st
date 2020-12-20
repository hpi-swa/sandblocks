as yet unclassified
updateSuggestions

	| suggestions |
	suggestions := self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text |
			text first isUppercase
				ifTrue: [self uppercaseSuggestions]
				ifFalse: [self lowercaseSuggestions]].
	self updateSuggestions: suggestions showNear: self