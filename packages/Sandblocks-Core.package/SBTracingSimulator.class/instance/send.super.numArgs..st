as yet unclassified
send: selector super: supered numArgs: numArgs

	| res |
	" hack to speed up our tooling, we perform: instead of simulating "
	(selector == #addInvocation:value:from:expression: or:
	[selector == #halt or:
	[selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]]) ifTrue: [
		res := (super send: selector super: supered numArgs: numArgs) runUntilErrorOrReturnFrom: currentContext.
		^ res first].
	
	" find array stores "
	selector == #at:put: ifTrue: [ | lookupClass receiver method |
		receiver := currentContext at: currentContext stackPtr - numArgs - 1.
		lookupClass := supered
			ifTrue: [currentContext method methodClassAssociation value superclass]
			ifFalse: [currentContext objectClass: receiver].
		method := lookupClass lookupSelector: selector.
		(method notNil and: [method primitive = 61]) ifTrue: [
			self
				reportSideEffectTo: receiver
				named: 'at: ', (currentContext at: currentContext stackPtr - 1)
				value: (currentContext at: currentContext stackPtr) asString]].
	
	res := super send: selector super: supered numArgs: numArgs.
	(selector == #basicNew or: [selector == #basicNew:]) ifTrue: [tempObjects add: res top].
	^ res