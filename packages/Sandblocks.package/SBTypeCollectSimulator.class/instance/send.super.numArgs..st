as yet unclassified
send: selector super: supered numArgs: numArgs

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: (currentContext at: currentContext stackPtr - numArgs)].
	
	(lookupClass lookupSelector: selector) ifNotNil: [:method |
		" report argument types "
		(currentContext stackPtr - numArgs to: currentContext stackPtr) withIndexDo: [:stackIndex :index |
			self
				reportTypeInfo: (currentContext at: stackIndex)
				at: (SBCodeContext class: lookupClass selector: selector)
				findNode: [:methodMorph | methodMorph arguments at: index]].
		
		" report primitives "
		method primitive > 0 ifTrue: [ | ret |
			" perform:withArguments "
			method primitive = 84 ifTrue: [ | actualSelector |
				actualSelector := currentContext at: currentContext stackPtr - 1.
				(currentContext at: currentContext stackPtr) withIndexDo: [:argument :index |
					self
						reportTypeInfo: argument
						at: (SBCodeContext class: lookupClass selector: actualSelector)
						findNode: [:methodMorph | methodMorph arguments at: index]].].
			self flag: #todo. " other perform: variants "
			
			ret := super send: selector super: supered numArgs: numArgs.
			(currentContext isDead not and: [currentContext stackPtr > 0]) ifTrue: [self reportTypeInfo: currentContext top at: currentContext].
			^ ret]].
	
	^ super send: selector super: supered numArgs: numArgs