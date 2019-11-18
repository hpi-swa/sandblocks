actions
promptSwitchMethodNewWindow: aBoolean

	| methods index class |
	self flag: #todo. " choose class "
	class := self methods first methodClass.
	methods := class methodDict keys.
	index := UIManager default chooseFrom: methods.
	index > 0 ifTrue: [ | method |
		method  := class >> (methods at: index).
		
		self openCompiledMethod: method
		"aBoolean
			ifTrue: [SBEditor openFor: method] ifFalse: [self compiledMethod: method]"]