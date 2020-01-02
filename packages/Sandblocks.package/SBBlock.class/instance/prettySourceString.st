as yet unclassified
prettySourceString

	^ SBFormatter formatString: self sourceString class: self containingMethod methodClass noPattern: self ~= self containingMethod
	
	"false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: []]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingMethod methodClass notifying: nil]."