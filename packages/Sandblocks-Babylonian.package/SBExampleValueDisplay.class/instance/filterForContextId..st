as yet unclassified
filterForContextId: aNumber

	| frames |
	frames := values select: [:probedValue |
		probedValue frames anySatisfy: [:frame | frame contextIdentityHash = aNumber]].
	
	self flag: #todo.
	frames ifNotEmpty: [display reportValue: frames first value]