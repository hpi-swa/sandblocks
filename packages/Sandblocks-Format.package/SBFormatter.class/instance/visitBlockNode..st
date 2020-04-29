as yet unclassified
visitBlockNode: aNode

	| isMethodBlock startWithNewLine temporaries |
	SBLabel text: ['TODO: pragmas'].
	isMethodBlock := (self parentFor: aNode) isKindOf: MethodNode.
	isMethodBlock ifFalse: [
		stream nextPut: $[.
		aNode arguments ifNotEmpty: [:args | 
			args do: [:arg | 
				stream nextPut: $:.
				stream nextPutAll: arg name.
				stream space].
			stream nextPutAll: '| ']].
	self formatTemporariesOf: aNode isMethod: isMethodBlock.
	startWithNewLine := isMethodBlock not and: [aNode statements size > 1 or: [self willBeMultiLine: aNode statements first]].
	self
		indent: (startWithNewLine ifTrue: [1] ifFalse: [0])
		around: [ | first |
			startWithNewLine ifTrue: [self newLine].
			first := true.
			(self blockStatementsOf: aNode) do: [:statement | self visitNode: statement] separatedBy: [
				stream nextPut: $..
				self newLine]].
	isMethodBlock ifFalse: [stream nextPut: $]]