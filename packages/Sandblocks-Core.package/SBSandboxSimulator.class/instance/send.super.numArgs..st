as yet unclassified
send: selector super: supered numArgs: numArgs

	| res receiver lookupClass |
	receiver := currentContext at: currentContext stackPtr - numArgs.
	(self method: selector for: receiver super: supered numArgs: numArgs) ifNotNil: [:method |
		method primitive = 117 ifTrue: [ | module call |
			(self isAllowedExternalCall: method) ifFalse: [^ SBExampleWatch report: nil for: 786950473]].
		(self isBlacklistedPrimitive: method) ifTrue: [^ SBExampleWatch report: nil for: 952327429].
		(self createsObject: method) ifTrue: [
			res := super send: selector super: supered numArgs: numArgs.
			tempObjects add: res top.
			^ res].
		(self causesSideEffect: method) ifTrue: [
			currentContext.
			(tempObjects includes: receiver) ifFalse: [^ SBExampleWatch report: nil for: 923157428]].
		^ super send: selector super: supered numArgs: numArgs].
	^ super send: selector super: supered numArgs: numArgs