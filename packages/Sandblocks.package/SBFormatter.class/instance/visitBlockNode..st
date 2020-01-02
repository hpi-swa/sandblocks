as yet unclassified
visitBlockNode: aNode 
	| isMethodBlock startWithNewLine |
	SBLabel
		text: ['TODO: pragmas'].
	isMethodBlock := (self parentFor: aNode)
				isKindOf: MethodNode.
	isMethodBlock
		ifFalse: [stream nextPut: $[.
			aNode arguments
				ifNotEmpty: [:args | 
					args
						do: [:arg | 
							stream nextPut: $:.
							stream nextPutAll: arg name.
							stream space].
					stream nextPutAll: '| ']].
	aNode temporaries
		ifNotEmpty: [:temps | 
			isMethodBlock
				ifFalse: [stream space].
			stream nextPutAll: '| '.
			temps
				do: [:temp | stream nextPutAll: temp name]
				separatedBy: [stream space].
			stream nextPutAll: ' |'.
			isMethodBlock
				ifTrue: [self newLine]].
	startWithNewLine := isMethodBlock not
				and: [aNode statements size > 1
						or: [self willBeMultiLine: aNode statements first]].
	self
		indent: (startWithNewLine
				ifTrue: [1]
				ifFalse: [0])
		around: [startWithNewLine
				ifTrue: [self newLine].
			(self blockStatementsOf: aNode)
				do: [:statement | self visitNode: statement]
				separatedBy: [stream nextPut: $..
					self newLine]].
	isMethodBlock
		ifFalse: [stream nextPut: $]]