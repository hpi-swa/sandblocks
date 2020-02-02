as yet unclassified
send: selector super: supered numArgs: numArgs

	| res |
	" hack to speed up our tooling, we perform: instead of simulating "
	(selector == #addInvocation:value:from:expression: or:
		[selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]) ifTrue: [  
		
		"^ currentContext push: (SBSimulator new simulateContext: (super send: selector super: supered numArgs: numArgs) untilReached: currentContext)."
		res := (super send: selector super: supered numArgs: numArgs) runUntilErrorOrReturnFrom: currentContext.
		^ res first.
		"
		| arguments thisReceiver lookupClass |
		arguments := Array new: numArgs.
		numArgs to: 1 by: -1 do: [ :i | arguments at: i put: currentContext pop].
		thisReceiver := currentContext pop.
		
		lookupClass := supered
					ifTrue: [currentContext method methodClassAssociation value superclass]
					ifFalse: [currentContext objectClass: thisReceiver].
		^ currentContext push: (thisReceiver perform: selector withArguments: arguments)
		currentContext object: thisReceiver perform: selector withArguments: arguments inClass: lookupClass"].
	
	res := super send: selector super: supered numArgs: numArgs.
	(selector == #basicNew or: [selector == #basicNew:]) ifTrue: [tempObjects add: res top].
	^ res