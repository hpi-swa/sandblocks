as yet unclassified
send: selector super: supered numArgs: numArgs

	| res |
	" hack to speed up our tooling, we perform: instead of simulating "
	(selector == #addInvocation:value:from:expression: or:
	[selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]) ifTrue: [  
		res := (super send: selector super: supered numArgs: numArgs) runUntilErrorOrReturnFrom: currentContext.
		^ res first].
	
	res := super send: selector super: supered numArgs: numArgs.
	(selector == #basicNew or: [selector == #basicNew:]) ifTrue: [tempObjects add: res top].
	^ res