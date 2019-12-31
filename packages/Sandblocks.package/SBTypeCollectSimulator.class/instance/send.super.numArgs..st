as yet unclassified
send: selector super: supered numArgs: numArgs

	| arguments receiver location res |
	receiver := currentContext at: currentContext stackPtr - numArgs. selector.
	arguments := (currentContext stackPtr - numArgs + 1 to: currentContext stackPtr) collect: [:index | currentContext at: index].
	
	"Transcript showln: {currentContext pc - 1. receiver. selector. arguments.}"
	location := SBCodeContext for: currentContext.
	res := super send: selector super: supered numArgs: numArgs.
	currentContext stackPtr > 0 ifTrue: ["editor reportTypeInfo: currentContext top at: location"].
	^ res