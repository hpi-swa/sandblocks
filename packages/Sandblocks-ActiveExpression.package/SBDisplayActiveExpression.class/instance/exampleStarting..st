as yet unclassified
exampleStarting: anExample

	invocations exampleStarting: anExample.
	marbles exampleStarting: anExample.
	
	expressions keysAndValuesDo: [:expression :callback |
		(expressions respondsTo: #afterInvokeDo:) ifTrue: [expression afterInvokeDo: nil]].
	expressions removeAll