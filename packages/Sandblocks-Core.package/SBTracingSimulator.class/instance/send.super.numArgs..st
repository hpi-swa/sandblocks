instruction decoding
send: selector super: supered numArgs: numArgs

	| res |
	(selector == #addInvocation:value:from:expression: or: [selector == #halt or: [selector == #notify:instVarNamed:ofObject:changedFrom:to:inContext:]]) ifTrue: [
		res := (super send: selector super: supered numArgs: numArgs) runUntilErrorOrReturnFrom: currentContext.
		^ res first].
	(selector == #at:put: or: [selector == #new:]) ifTrue: [ | lookupClass receiver |
		receiver := currentContext at: currentContext stackPtr - numArgs.
		lookupClass := supered
			ifTrue: [currentContext method methodClassAssociation value superclass]
			ifFalse: [currentContext objectClass: receiver].
		(lookupClass lookupSelector: selector) ifNotNil: [:method | 
			method primitive = 71 ifTrue: [
				res := super send: selector super: supered numArgs: numArgs.
				tempObjects add: res top.
				^ res].
			(method primitive = 61 and: [(tempObjects includes: receiver) not]) ifTrue: [
				self
					reportSideEffectTo: receiver
					named: 'at: ', (currentContext at: currentContext stackPtr - 1)
					value: (currentContext at: currentContext stackPtr) asString]]].
	res := super send: selector super: supered numArgs: numArgs.
	(selector == #basicNew or: [selector == #basicNew:]) ifTrue: [tempObjects add: res top].
	^ res