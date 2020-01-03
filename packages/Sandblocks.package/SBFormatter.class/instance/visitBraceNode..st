as yet unclassified
visitBraceNode: aNode

	| length multiLine |
	length := aNode elements inject: 0 into: [:sum :node | sum + (self preFormat: node) size].
	multiLine := length > self maxLineLength.
	stream nextPut: ${.
	self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [
		multiLine ifTrue: [self newLine].
		aNode elements
			do: [:element | self visitNode: element]
			separatedBy: [stream nextPut: $.. multiLine ifTrue: [self newLine] ifFalse: [stream space]]].
	multiLine ifTrue: [self newLine].
	stream nextPut: $}