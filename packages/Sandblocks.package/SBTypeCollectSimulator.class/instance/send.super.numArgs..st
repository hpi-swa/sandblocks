as yet unclassified
send: selector super: supered numArgs: numArgs

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: currentContext top].
	
	(lookupClass lookupSelector: selector) ifNotNil: [:method |
		method primitive > 0 ifTrue: [ | ret |
			ret := super send: selector super: supered numArgs: numArgs.
			(currentContext isDead not and: [currentContext stackPtr > 0]) ifTrue: [self reportTypeInfo: currentContext top at: currentContext].
			^ ret]].
	
	^ super send: selector super: supered numArgs: numArgs