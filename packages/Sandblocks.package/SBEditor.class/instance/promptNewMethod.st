actions
promptNewMethod

	| selectorAndArguments |
	selectorAndArguments := (SBRequestSelector open) ifNil: [^ self].
		
	SBEditor new
		method: (SBMethod new
			selector: selectorAndArguments first
			arguments: selectorAndArguments second veryDeepCopy
			class: self method methodClass;
			body: SBBlockBody new);
		openInWindow