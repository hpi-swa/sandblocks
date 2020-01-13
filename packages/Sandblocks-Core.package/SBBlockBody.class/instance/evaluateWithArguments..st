as yet unclassified
evaluateWithArguments: aCollection

	^ (Compiler evaluate: self sourceString) valueWithEnoughArguments: aCollection