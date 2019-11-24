as yet unclassified
relevantContextsFrom: aContext

	| sendingContext |
	sendingContext := (aContext findContextSuchThat: [:context |
		context receiver = VarTra and:
		[context selector =  #notify:instVarNamed:ofObject:changedFrom:to:inContext:]
		and: [context isMethodContext]]) sender.
	
	^ Array streamContents: [:stream  | | ctx |
		stream nextPut: (ctx := sendingContext).
		[(ctx := ctx sender) ~~ nil and: [ctx selector ~= #run and: [ctx receiver class ~= SBExample]]]
			whileTrue: [stream nextPut: ctx]]