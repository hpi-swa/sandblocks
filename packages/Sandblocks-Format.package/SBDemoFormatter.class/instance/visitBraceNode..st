as yet unclassified
visitBraceNode: aNode

	| width multiLine |
	1 / 0.
	width := aNode elements inject: 0 into: [:sum :element | sum + ((self preFormat: element) size + 2)].
	multiLine := width > self maxLineLength.
	stream nextPut: ${.
	self
		indent: (multiLine ifTrue: [1] ifFalse: [0])
		around: [
			aNode elements
				do: [:element | self visitNode: element]
				separatedBy: [
					stream
						nextPut: $.;
						space.
					multiLine ifTrue: [stream cr]]].
	stream nextPut: $}