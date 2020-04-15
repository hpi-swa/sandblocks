as yet unclassified
visitMessageNode: aNode

	| multiLine newLineAfterReceiver isInCascade |
	isInCascade := ((self parentFor: aNode) isKindOf: CascadeNode) and: [(self parentFor: aNode) originalReceiver ~= aNode].
	isInCascade ifFalse: [self visitNode: aNode originalReceiver].
	aNode originalSelector isUnary ifTrue: [
		isInCascade ifFalse: [stream space].
		^ stream nextPutAll: aNode originalSelector].
	multiLine := self isMultiLineMessage: aNode.
	aNode originalSelector isBinary ifTrue: [
		aNode originalSelector ~= #, ifTrue: [stream space].
		stream
			 nextPutAll: aNode originalSelector;
			 space.
		self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [self visitNode: aNode arguments first].
		^ self].
	newLineAfterReceiver := multiLine and: [aNode originalSelector keywords size > 1].
	self indent: (newLineAfterReceiver ifTrue: [1] ifFalse: [0])
	around: [
		isInCascade ifFalse: [newLineAfterReceiver ifTrue: [self newLine] ifFalse: [stream space]].
		self with: aNode originalSelector keywords
		and: aNode originalArguments
		do: [:keyword :argument | 
			stream nextPutAll: keyword.
			stream space.
			self visitNode: argument]
		separatedBy: [multiLine ifTrue: [self newLine] ifFalse: [stream space]]]