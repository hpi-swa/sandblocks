compilation cue protocol
evaluateWith: aRequestor for: aContext

	^ Compiler new evaluate: (self body sourceString, ' value') readStream in: aContext to: (aContext ifNotNil: #receiver) notifying: aRequestor ifFail: nil