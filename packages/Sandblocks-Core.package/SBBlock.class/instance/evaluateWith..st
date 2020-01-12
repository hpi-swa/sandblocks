as yet unclassified
evaluateWith: aRequestor

	^ Compiler evaluate:  self sourceString readStream for: nil notifying: aRequestor