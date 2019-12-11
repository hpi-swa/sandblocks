as yet unclassified
prettySourceString

	| text |
	text := self sourceString.
	self flag: #todo. "currently no support for partial methods "
	
	false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: ["leave unchanged"]]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingMethod methodClass notifying: nil].
	^ text