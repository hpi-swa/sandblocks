as yet unclassified
updateSuggestions

	| suggestions |
	suggestions := self contents
		ifEmpty: [#()]
		ifNotEmpty: [:text |
			text first isUppercase
				ifTrue: [Smalltalk classNames select: [:cls | cls beginsWith: text]]
				ifFalse: [#()]].
	self updateSuggestions: suggestions showNear: self