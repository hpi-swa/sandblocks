as yet unclassified
printBraceNode2: aBraceNode on: aWriteStream

	| multiLine width |
	width := aBraceNode elements inject: 0 into: [:sum :element | sum + (self preFormat: element) size].
	multiLine := width > self maxLineLength.
	
	aWriteStream nextPut: ${.
	self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [
	aBraceNode elements do: [:element | self visitNode: element] separatedBy: [aWriteStream nextPut: $.. multiLine ifTrue: [aWriteStream cr]]].
	aWriteStream nextPut: $}