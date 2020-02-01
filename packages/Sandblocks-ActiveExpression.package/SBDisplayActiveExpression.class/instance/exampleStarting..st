as yet unclassified
exampleStarting: anExample

	invocations exampleStarting: anExample.
	marbles exampleStarting: anExample.
	
	expressions keysAndValuesDo: [:expression :callback |
		expression afterInvokeDo: nil].
	expressions removeAll