as yet unclassified
relevantContextsFrom: aContext

	| sendingContext res |
	sendingContext := (aContext findContextSuchThat: [:context |
		context receiver = VarTra and:
		[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
		and: [context isMethodContext]]) ifNotNil: #sender ifNil: [^ aContext stack].
	
	res := Array streamContents: [:stream  | | ctx |
		stream nextPut: (SBCodeContext for: (ctx := sendingContext)).
		[(ctx := ctx sender) ~~ nil and: [ctx selector ~= #run and: [ctx receiver class ~= SBExample]]]
			whileTrue: [stream nextPut: ((SBCodeContext for: ctx) pc: ctx previousPc)]].
	
	self flag: #fixme. " the first invocation had the generated AE check code before its actual invocation. it is currently 10 bytes large, but maybe we can find a more robust way to adjust this? "
	res ifNotEmpty: [res first pc: res first pc - 10].
	^ res