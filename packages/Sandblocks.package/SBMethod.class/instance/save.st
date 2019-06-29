as yet unclassified
save

	| text |
	text := self sourceString.
	Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text].
	self methodClass compile: text asText