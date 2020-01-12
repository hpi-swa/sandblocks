as yet unclassified
visitMessageNode: aNode

	| multiLine |
	(((self parentFor: aNode) isKindOf: CascadeNode) not or: [(self parentFor: aNode) originalReceiver = aNode]) ifTrue: [self visitNode: aNode originalReceiver].
	
	aNode originalSelector isUnary ifTrue: [
		^ stream
			 space;
			 nextPutAll: aNode originalSelector].
	
	multiLine := self isMultiLineMessage: aNode.
	
	aNode originalSelector isBinary
		ifTrue: [
			aNode originalSelector ~= #, ifTrue: [stream space].
			stream nextPutAll: aNode originalSelector; space.
			self indent: (multiLine ifTrue: [1] ifFalse: [0]) around: [self visitNode: aNode arguments first].
			^ self].
	
	self
		indent: (multiLine ifTrue: [1] ifFalse: [0])
		around: [
			multiLine ifTrue: [self newLine] ifFalse: [stream space].
			self
				with: aNode originalSelector keywords
				and: aNode originalArguments
				do: [:keyword :argument | 
					stream nextPutAll: keyword.
					stream space.
					self visitNode: argument]
				separatedBy: [multiLine ifTrue: [self newLine] ifFalse: [stream space]]]