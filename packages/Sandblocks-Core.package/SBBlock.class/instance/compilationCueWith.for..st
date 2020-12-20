as yet unclassified
compilationCueWith: aRequestor for: aContext

	| receiver class |
	receiver := aContext ifNotNil: #receiver.
	class := Compiler new classForReceiver: receiver context: aContext.
	^ CompilationCue
		source: self sourceString readStream
		context: aContext
		receiver: receiver
		class: class
		environment: class environment
		requestor: aRequestor