as yet unclassified
relevantContextsFrom: aContext

	| sendingContext res max |
	sendingContext := (aContext findContextSuchThat: [:context |
		context receiver = VarTra and:
		[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
		and: [context isMethodContext]]) ifNotNil: #sender ifNil: [^ aContext stack].
	
	max := 10.
	res := Array streamContents: [:stream  | | ctx |
		stream nextPut: (SBCodeContext for: (ctx := sendingContext)).
		["max > 0"true and: [(ctx := ctx sender) ~~ nil and: [ctx selector ~= #run and: [ctx receiver class ~= SBExample]]]]
			whileTrue: [
				max := max - 1.
				stream nextPut: ((SBCodeContext for: ctx) pc: ctx previousPc)]].
	
	self flag: #fixme. " the first invocation had the generated AE check code before its actual invocation. maybe we can find a more robust way to adjust this? "
	res ifNotEmpty: [res first pc: (res first method pcOfReceiverAssignmentBefore: res first pc)].
	^ res