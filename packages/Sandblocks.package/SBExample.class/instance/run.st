as yet unclassified
run

	| eval |
	eval :=  (SBMessageSend new
		receiver: (SBMessageSend new receiver: self selfBlock veryDeepCopy selector: #value)
		selector: self containingMethod selector
		arguments: self argumentsBlock childSandblocks last veryDeepCopy childSandblocks) sourceString.
	[Compiler evaluate: eval] on: Error do: [:e | ^ self lastError: e].
	self lastError: nil