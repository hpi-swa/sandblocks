as yet unclassified
visitNode: aNode 
	| needsParens |
	needsParens := self needsParenthesisFor: aNode.
	needsParens
		ifTrue: [stream nextPut: $(].
	preFormatCache
		at: aNode
		ifPresent: [:pair | stream
				nextPutAll: (self reindent: pair)]
		ifAbsent: [aNode accept: self].
	needsParens
		ifTrue: [stream nextPut: $)]