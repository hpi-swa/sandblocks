compilation cue protocol
evaluateWith: aRequestor

	^ Compiler evaluate: (self body sourceString, ' value') readStream for: nil notifying: aRequestor