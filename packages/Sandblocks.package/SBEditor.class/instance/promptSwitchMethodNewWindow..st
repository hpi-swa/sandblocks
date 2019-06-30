actions
promptSwitchMethodNewWindow: aBoolean

	| methods index |
	methods := self method methodClass methodDict keys.
	index := UIManager default chooseFrom: methods.
	index > 0 ifTrue: [ | method |
		method  := self method methodClass >> (methods at: index).
		aBoolean
			ifTrue: [SBEditor openFor: method] ifFalse: [self compiledMethod: method]]