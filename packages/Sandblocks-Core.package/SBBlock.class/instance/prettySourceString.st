as yet unclassified
prettySourceString

	^ SBFormatter formatString: self sourceString class: self containingArtefact methodClass noPattern: self ~= self containingArtefact
	
	"false
		ifTrue: [[Smalltalk at: #PPPPrinter ifPresent: [:p | text := p format: text]] on: Error do: []]
		ifFalse: [text := self class prettyPrinterClass format: text in: self containingArtefact methodClass notifying: nil]."