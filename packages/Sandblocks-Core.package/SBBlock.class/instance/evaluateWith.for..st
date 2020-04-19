as yet unclassified
evaluateWith: aRequestor for: aContext

	^ Compiler new evaluate: self sourceString readStream in: aContext to: (aContext ifNotNil: #receiver) notifying: aRequestor ifFail: nil