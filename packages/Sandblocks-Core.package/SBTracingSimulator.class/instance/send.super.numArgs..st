as yet unclassified
send: selector super: supered numArgs: numArgs

	| res |
	" hack to speed up our tooling, we perform: instead of simulating "
	"(selector == #addInvocation:value:from:expression: or:
		[selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]) ifTrue: [ | arguments thisReceiver |
		arguments := Array new: numArgs.
		numArgs to: 1 by: -1 do: [ :i | arguments at: i put: currentContext pop].
		thisReceiver := currentContext pop.
		^ currentContext push: (thisReceiver perform: selector withArguments: arguments)]."
	
	res := super send: selector super: supered numArgs: numArgs.
	selector = #basicNew ifTrue: [tempObjects add: res top].
	^ res