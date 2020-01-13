as yet unclassified
visitBlockNode: aNode

	| isMethodBlock startWithNewLine temporaries |
	SBLabel text: ['TODO: pragmas'].
	isMethodBlock := (self parentFor: aNode) isKindOf: MethodNode.
	isMethodBlock
		ifFalse: [
			stream nextPut: $[.
			aNode arguments ifNotEmpty: [:args | 
				args do: [:arg | 
					stream nextPut: $:.
					stream nextPutAll: arg name.
					stream space].
				stream nextPutAll: '| ']].
	temporaries := isMethodBlock ifTrue: [(self parentFor: aNode) temporaries] ifFalse: [aNode temporaries].
	temporaries ifNotEmpty: [:temps | 
		isMethodBlock ifFalse: [stream space].
		stream nextPutAll: '| '.
		temps do: [:temp | stream nextPutAll: temp name] separatedBy: [stream space].
		stream nextPutAll: ' |'.
		isMethodBlock ifTrue: [self newLine]].
	startWithNewLine := isMethodBlock not and: [aNode statements size > 1 or: [self willBeMultiLine: aNode statements first]].
	self
		indent: (startWithNewLine ifTrue: [1] ifFalse: [0])
		around: [ | first |
			startWithNewLine ifTrue: [self newLine].
			first := true.
			(self blockStatementsOf: aNode)
				do: [:statement | 
					self visitNode: statement.
					SBToggledCode
						comment: 'currently not working (intent: add a newline after a first super call)'
						active: 0
						do: {
							[
								first
									ifTrue: [
										first := false.
										statement isMessage and: [statement originalReceiver isVariableNode and: [statement originalReceiver key = 'super']]]]
						}]
				separatedBy: [
					stream nextPut: $..
					self newLine]].
	isMethodBlock ifFalse: [stream nextPut: $]]