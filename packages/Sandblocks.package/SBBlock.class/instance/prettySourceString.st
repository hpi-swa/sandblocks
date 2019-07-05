as yet unclassified
prettySourceString

	| text |
	text := self sourceString.
	self flag: #todo. "currently no support for partial methods " Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text].
	^ text