as yet unclassified
evaluateSelf

	^ Compiler evaluate: (SBMessageSend new receiver: self selfBlock veryDeepCopy selector: #value) sourceString