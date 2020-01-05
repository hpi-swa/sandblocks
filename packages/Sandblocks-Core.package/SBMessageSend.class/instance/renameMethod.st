accessing
renameMethod

	| selectorAndArguments otherEditor arguments selector |
	self isSendToSelf ifFalse: [^ self].
	
	otherEditor := SBEditor openFor: self containingArtefact methodClass >> self selector asSymbol.
	selectorAndArguments := (SBRequestSelector openForSelector: self selector arguments: otherEditor method arguments).
	selector := selectorAndArguments first.
	arguments := selectorAndArguments second.
	
	self flag: #todo. "undo?"
	otherEditor method selector: selector arguments: arguments.
	self selector: selector arguments: (self mergeArguments: self arguments declarations: arguments)