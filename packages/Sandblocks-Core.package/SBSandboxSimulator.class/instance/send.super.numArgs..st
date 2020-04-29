as yet unclassified
send: selector super: supered numArgs: numArgs

	| res receiver lookupClass |
	receiver := currentContext at: currentContext stackPtr - numArgs.
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: receiver].
	(lookupClass lookupSelector: selector) ifNotNil: [:method | 
		method primitive = 117 ifTrue: [ | module call |(self isAllowedExternalCall: method) ifFalse: [^ nil]].
		(self isBlacklistedPrimitive: method) ifTrue: [^ nil].
		(self createsObject: method) ifTrue: [
			res := super send: selector super: supered numArgs: numArgs.
			tempObjects add: res top.
			^ res].
		(self causesSideEffect: method) ifTrue: [
			currentContext.
			(tempObjects includes: receiver) ifFalse: [^ nil]].
		^ super send: selector super: supered numArgs: numArgs].
	^ super send: selector super: supered numArgs: numArgs