as yet unclassified
send: selector super: supered numArgs: numArgs

	| lookupClass |
	lookupClass := supered
		ifTrue: [currentContext method methodClassAssociation value superclass]
		ifFalse: [currentContext objectClass: (currentContext at: currentContext stackPtr - numArgs)].
	
	(lookupClass lookupSelector: selector) ifNotNil: [:method |
		" report argument types "
		(currentContext stackPtr - numArgs + 1 to: currentContext stackPtr) withIndexDo: [:stackIndex :index |
			SBCodeContext class: lookupClass selector: selector ifValid: [:location |
				self
					reportTypeInfo: (currentContext at: stackIndex)
					at: location
					findNode: [:methodMorph | methodMorph arguments at: index]]].
		
		" report primitives "
		method primitive > 0 ifTrue: [ | ret |
			" perform:withArguments "
			method primitive = 84 ifTrue: [ | actualSelector actualReceiver actualClass |
				actualReceiver := currentContext at: currentContext stackPtr - 2.
				actualSelector := currentContext at: currentContext stackPtr - 1.
				actualClass := ((currentContext objectClass: actualReceiver) lookupSelector: actualSelector) methodClass.
				(currentContext at: currentContext stackPtr) withIndexDo: [:argument :index |
					self
						reportTypeInfo: argument
						at: (SBCodeContext class: actualClass selector: actualSelector)
						findNode: [:methodMorph | methodMorph arguments at: index]].].
			self flag: #todo. " other perform: variants "
			
			ret := currentContext send: selector super: supered numArgs: numArgs.
			(currentContext isDead not and: [currentContext stackPtr > 0]) ifTrue: [self reportTypeInfo: currentContext top at: currentContext].
			
			" value:... block closure invocation "
			((method primitive between: 201 and: 209) or: [method primitive between: 221 and: 222]) ifTrue: [
				ret arguments withIndexDo: [:argument :index |
					self
						reportTypeInfo: argument
						at: (SBCodeContext for: ret)
						findNode: [:methodMorph | (methodMorph blockForPC: ret previousPc) ifNotNil: [:block | block bindings at: index]]]].
			
			^ ret]].
	
	^ currentContext send: (selector = #halt ifTrue: [#yourself] ifFalse: [selector]) super: supered numArgs: numArgs