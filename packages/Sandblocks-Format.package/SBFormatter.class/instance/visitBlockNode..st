as yet unclassified
visitBlockNode: aNode

	| isMethodBlock startWithNewLine |
	isMethodBlock := (self parentFor: aNode) isKindOf: MethodNode.
	startWithNewLine := isMethodBlock not and: [
		aNode statements size > 1 or: [self willBeMultiLine: aNode statements first]].
	
	isMethodBlock ifFalse: [
		stream nextPut: $[.
		aNode arguments ifNotEmpty: [:args |
			args do: [:arg |
				stream nextPut: $:.
				stream nextPutAll: arg name.
				stream space].
			stream nextPut: $|.
			startWithNewLine ifFalse: [stream space]]].
	
	self formatTemporariesOf: aNode isMethod: isMethodBlock.
	
	self
		indent: (startWithNewLine ifTrue: [1] ifFalse: [0])
		around: [ | statements |
			statements := self blockStatementsOf: aNode.
			startWithNewLine ifTrue: [self newLine].
			
			statements do: [:statement |
				(statement isLiteralNode and: [statement key = #sbEmptyLine])
					ifTrue: [self newLine]
					ifFalse: [
						self visitNode: statement.
						statement ~= statements last ifTrue: [
							stream nextPut: $..
							self newLine]]]].
	isMethodBlock ifFalse: [stream nextPut: $]]