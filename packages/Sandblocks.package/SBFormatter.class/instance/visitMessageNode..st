as yet unclassified
visitMessageNode: aNode 
	| multiLine |
	((self parentFor: aNode)
			isKindOf: CascadeNode)
		ifFalse: [self visitNode: aNode receiver].
	aNode originalSelector isUnary
		ifTrue: [^ stream space; nextPutAll: aNode originalSelector].
	multiLine := self isMultiLineMessage: aNode.
	self
		indent: (multiLine
				ifTrue: [1]
				ifFalse: [0])
		around: [multiLine
				ifTrue: [self newLine]
				ifFalse: [stream space].
			self
				with: aNode originalSelector keywords
				and: aNode originalArguments
				do: [:keyword :argument | 
					stream nextPutAll: keyword.
					stream space.
					self visitNode: argument]
				separatedBy: [multiLine
						ifTrue: [self newLine]
						ifFalse: [stream space]]]